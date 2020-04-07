clc;
clear all;
close all;

%% Code and Network Parameters
% 0 = Position Control
% 1 = Velocity Control
Scheme = 1;

% Hyperparameters
In = 2;
H1 = 10
H2 = 7
H3 = 5
Out = 2;
coeff_rand = 0.01;
coeff_arand = 0.02; % 0.03
eta0 = 0.0005;  % 0.0001 for 1 0.0000001 for 0
s = 20;
epochs = 200;
t_steps = 6001;

sim('config5sim_KinematicController.slx');
disp('Start')

%% Prework
if Scheme == 0
    ref1 = x_ref;
    ref2 = y_ref;
    P1 = xP;
    P2 = yP;
elseif Scheme == 1
    ref1 = vref;
    ref2 = wref;
    P1 = vP;
    P2 = wP;
else
    error('Scheme Not Found')
end
        
    % Mean and Standard Deviation
ref1_mean = mean(ref1);
ref2_mean = mean(ref2);
P1_mean = mean(P1);
P2_mean = mean(P2);

ref1_std = sqrt(var(ref1));
ref2_std = sqrt(var(ref2));
P1_std = sqrt(var(P1));
P2_std = sqrt(var(P2));

vPcmd_mean = mean(vPcmd);
wPcmd_mean = mean(wPcmd);
vPcmd_std = sqrt(var(vPcmd));
wPcmd_std = sqrt(var(wPcmd));

    % Normalising via centre about mean)
ref1_norm = (ref1(:) - ref1_mean)/ref1_std;
ref2_norm = (ref2(:) - ref1_mean)/ref2_std;
P1_norm = (P1(:) - P1_mean)/P1_std;
P2_norm = (P2(:) - P2_mean)/P2_std;
vPcmd_norm = (vPcmd(:) - vPcmd_mean)/vPcmd_std;
wPcmd_norm = (wPcmd(:) - wPcmd_mean)/wPcmd_std;

    % Minimum, Maximum, and Range for Scaling
ref1_min = min(ref1_norm);
ref1_max = max(ref1_norm);
ref2_min = min(ref2_norm);
ref2_max = max(ref2_norm);
P1_min = min(P1_norm);
P1_max = max(P1_norm);
P2_min = min(P2_norm);
P2_max = max(P2_norm);
vPcmd_max = max(vPcmd_norm);
vPcmd_min = min(vPcmd_norm);
wPcmd_max = max(wPcmd_norm);
wPcmd_min = min(wPcmd_norm);

ref1_rng = ref1_max - ref1_min;
ref2_rng = ref2_max - ref2_min;
P1_rng = (P1_max - P1_min);
P2_rng = (P2_max - P2_min);  
vPcmd_rng = (vPcmd_max - vPcmd_min);
wPcmd_rng = (wPcmd_max - wPcmd_min);

%% Trailer MSE
    % Position
xQMSElossK = sum((x_ref - xQ).^2)/t_steps;
yQMSElossK = sum((y_ref - yQ).^2)/t_steps;
QMSElossK_pos = xQMSElossK + yQMSElossK;
    % Velocity
vQMSElossK = sum((vref - vQ).^2)/t_steps;
wQMSElossK = sum((wref - wQ).^2)/t_steps;
QMSElossK_vel = vQMSElossK + wQMSElossK;

%% Robot MSE
    % Positions
xPMSElossK = sum((x_ref - xP).^2)/t_steps;
yPMSElossK = sum((y_ref - yP).^2)/t_steps;
PMSElossK_pos = xPMSElossK + yPMSElossK;
    % Velocities
vPMSElossK = sum((vref - vP).^2)/t_steps;
wPMSElossK = sum((wref - wP).^2)/t_steps;
PMSElossK_vel = vPMSElossK + wPMSElossK;

%% Simulation time MSE
XYQMSEK = (1/2)*((x_ref - xQ).^2 + (y_ref -yQ).^2);
XYPMSEK = (1/2)*((x_ref - xP).^2 + (y_ref -yP).^2);

% Initialize
PMSEKNN_pos = [];
PMSEK_pos = [];
QMSEK_pos = [];
QMSEKNN_pos = [];

PMSEKNN_vel = [];
PMSEK_vel = [];
QMSEK_vel = [];
QMSEKNN_vel = [];
eta_new = eta0;
sumse = [];
for i = 1:epochs
    eta = eta_new;
    eta_new = eta0*0.1^(i/s);
    if i == 1
        W1_i = coeff_rand*(rand(H1,In+1) - rand(H1,In+1));
        W2_i = coeff_rand*(rand(H2,H1+1) - rand(H2, H1+1));
        W3_i = coeff_rand*(rand(H3,H2+1) - rand(H3,H2+1));
        W4_i = coeff_rand*(rand(Out,H3+1) - rand(Out,H3+1));
        Weights1 = W1_i;
        Weights2 = W2_i;
        Weights3 = W3_i;
        Weights4 = W4_i;
    else
        W1_i = W1_out(:,:, end);
        W2_i = W2_out(:,:, end);
        W3_i = W3_out(:,:, end);
        W4_i = W4_out(:,:, end); 
    end
    
    sim('config5sim_KinematicController_Main.slx');

    % Trailer MSE
        % Position
    xQMSEloss = sum((x_ref - xQ).^2)/t_steps;
    yQMSEloss = sum((y_ref - yQ).^2)/t_steps;
    QMSEloss_pos = xQMSEloss + yQMSEloss;
    QMSEK_pos = cat(2, QMSEK_pos, QMSElossK_pos);
    QMSEKNN_pos = cat(2, QMSEKNN_pos, QMSEloss_pos);
    
        % Velocities
    vQMSEloss = sum((ref1 - vQ).^2)/t_steps;
    wQMSEloss = sum((ref2 - wQ).^2)/t_steps;
    QMSEloss_vel = vQMSEloss + wQMSEloss;
    QMSEK_vel = cat(2, QMSEK_vel, QMSElossK_vel);
    QMSEKNN_vel = cat(2, QMSEKNN_vel, QMSEloss_vel);
    
    % Robot MSE
        % Position
    xPMSEloss = sum((x_ref - xP).^2)/t_steps;
    yPMSEloss = sum((y_ref - yP).^2)/t_steps;
    PMSEloss_pos = xPMSEloss + yPMSEloss;
    PMSEK_pos = cat(2, PMSEK_pos, PMSElossK_pos);
    PMSEKNN_pos = cat(2, PMSEKNN_pos, PMSEloss_pos);
    
        % Velocity
    vPMSEloss = sum((vref - vP).^2)/t_steps;
    wPMSEloss = sum((wref - wP).^2)/t_steps;
    PMSEloss_vel = vPMSEloss + wPMSEloss;
    PMSEK_vel = cat(2, PMSEK_vel, PMSElossK_vel);
    PMSEKNN_vel = cat(2, PMSEKNN_vel, PMSEloss_vel);
    
    % Simulated Annealing
    if i > 3
        diff_PMSE = PMSEKNN_vel(i)-PMSEKNN_vel(i-1);
        diff_QMSE = QMSEKNN_vel(i)-QMSEKNN_vel(i-1);
        if diff_PMSE < 0.05*PMSEKNN_vel(i) && diff_QMSE < 0.05*QMSEKNN_vel(i)
            W1_out(:,:, end) = W1_out(:,:, end) + 0.1*coeff_arand*rand(size(W1_out, 1), size(W1_out, 2));
            W2_out(:,:, end) = W2_out(:,:, end) + 0.1*coeff_arand*rand(size(W2_out, 1), size(W2_out, 2));
            W3_out(:,:, end) = W3_out(:,:, end) + 0.1*coeff_arand*rand(size(W3_out, 1), size(W3_out, 2));
            W4_out(:,:, end) = W4_out(:,:, end) + 0.1*coeff_arand*rand(size(W4_out, 1), size(W4_out, 2));
        end
    end
        
%     figure(2)
%     title('Positions')
%     subplot(2,1,1)
%     plot([0:i-1],QMSEK_pos,'-r')
%     hold on
%     plot([0:i-1],QMSEKNN_pos,'-b')
%     legend('Kinematic Robot', 'K + NN Robot')
%     xlabel('Epochs')
%     ylabel('MSEloss (X + Y total)')
% 
%     subplot(2,1,2)
%     plot([0:i-1],PMSEK_pos,'-r')
%     hold on
%     plot([0:i-1],PMSEKNN_pos,'-b')
%     legend('Kinematic Trailer', 'K + NN Trailer')
%     xlabel('Epochs')
%     ylabel('MSEloss (X + Y total)')
%     
%     figure(3)
%     title('Velocities')
%     subplot(2,1,1)
%     plot([0:i-1],QMSEK_vel,'-r')
%     hold on
%     plot([0:i-1],QMSEKNN_vel,'-b')
%     legend('Kinematic Robot', 'K + NN Robot')
%     xlabel('Epochs')
%     ylabel('MSEloss (V + W total)')
% 
%     subplot(2,1,2)
%     plot([0:i-1],PMSEK_vel,'-r')
%     hold on
%     plot([0:i-1],PMSEKNN_vel,'-b')
%     legend('Kinematic Trailer', 'K + NN Trailer')
%     xlabel('Epochs')
%     ylabel('MSEloss (V + W total)')

    XYQMSEKNN = (1/2)*((x_ref - xQ).^2 + (y_ref - yQ).^2);
    XYPMSEKNN = (1/2)*((x_ref - xP).^2 + (y_ref - yP).^2);

    figure(2)
    subplot(2, 1, 1)
    plot(tq, XYQMSEK,'-r')
    hold on
    plot(tq, XYQMSEKNN,'-b')
    legend('Kinematic Robot', 'K + NN Robot')
    xlabel('Time')
    ylabel('Combined Error (X + Y)')
    title(['Epoch ' num2str(i)])
    
    subplot(2, 1, 2)
    plot(tq, XYPMSEK,'-r')
    hold on
    plot(tq, XYPMSEKNN,'-b')
    legend('Kinematic Trailer', 'K + NN Trailer')
    xlabel('Time')
    ylabel('Combined Error (X + Y)')
    axis([0 inf 0 0.2])

    disp(i)
    
    if sum(XYPMSEKNN) < sum(XYPMSEK) && i >10
        sumse = cat(2, sumse, sum(XYPMSEKNN))
         if length(sumse) > 1 && sumse(end) > sumse(end-1) 
            figure(3)
            plot(xyref.DATA(:,1),xyref.DATA(:,2),'--black')
            hold on
            plot(xy_axon.DATA(:,1),xy_axon.DATA(:,2),'red')
            hold on
            plot(xy_trolley.DATA(:,1),xy_trolley.DATA(:,2),'green')
            xlabel('x-position')
            ylabel('y-position')
            legend('Reference trajectory', 'Robot trajectory', 'Trailer trajectory')

            figure(4)
            subplot(2, 1, 1)
            plot(tq, XYQMSEK,'-r')
            hold on
            plot(tq, XYQMSEKNN,'-b')
            legend('Kinematic Robot', 'K + NN Robot')
            xlabel('Time')
            ylabel('Combined Error (X + Y)')
            title(['Epoch ' num2str(i)])

            subplot(2, 1, 2)
            plot(tq, XYPMSEK,'-r')
            hold on
            plot(tq, XYPMSEKNN,'-b')
            legend('Kinematic Trailer', 'K + NN Trailer')
            xlabel('Time')
            ylabel('Combined Error (X + Y)')
            axis([0 inf 0 0.2])
            break 
        end
    end
end