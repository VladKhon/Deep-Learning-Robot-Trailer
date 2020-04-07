clc;
clear all;
sim('config5sim_KinematicController.slx');
disp('Start')

% Prework
    % Mean and Standard Deviation
vref_mean = mean(vref);
wref_mean = mean(wref);
vP_mean = mean(vP);
wP_mean = mean(wP);

vref_std = sqrt(var(vref));
wref_std = sqrt(var(wref));
vP_std = sqrt(var(vP));
wP_std = sqrt(var(wP));

    % Normalising via centre about mean)
vref_norm = (vref(:) - vref_mean)/vref_std;
wref_norm = (wref(:) - vref_mean)/wref_std;
vP_norm = (vP(:) - vP_mean)/vP_std;
wP_norm = (wP(:) - wP_mean)/wP_std;

    % Minimum, Maximum, and Range for Scaling
vref_min = min(vref_norm);
vref_max = max(vref_norm);
wref_min = min(wref_norm);
wref_max = max(wref_norm);
vP_min = min(vP_norm);
vP_max = max(vP_norm);
wP_min = min(wP_norm);
wP_max = max(wP_norm);
vref_rng = vref_max - vref_min;
wref_rng = wref_max - wref_min;
vP_rng = (vP_max - vP_min);
wP_rng = (wP_max - wP_min);  

% Network Parameters
In = 2;
H1 = 7;
H2 = 5;
H3 = 4;
Out = 2;
coeff_rand = 0;
epochs = 150;

% Trailer MSE
    % Position
xQMSElossK = sum((x_ref - xQ).^2)/6001;
yQMSElossK = sum((y_ref - yQ).^2)/6001;
QMSElossK_pos = xQMSElossK + yQMSElossK;
    % Velocity
vQMSElossK = sum((vref - vQ).^2)/6001;
wQMSElossK = sum((wref - wQ).^2)/6001;
QMSElossK_vel = vQMSElossK + wQMSElossK;

% Robot MSE
    % Positions
xPMSElossK = sum((x_ref - xP).^2)/6001;
yPMSElossK = sum((y_ref - yP).^2)/6001;
PMSElossK_pos = xPMSElossK + yPMSElossK;

    % Velocities
vPMSElossK = sum((vref - vP).^2)/6001;
wPMSElossK = sum((wref - wP).^2)/6001;
PMSElossK_vel = vPMSElossK + wPMSElossK;


% What Prof wants
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

for i = 1:epochs
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
    
    sim('config5sim_KinematicController_VW_NetFunc.slx');

    % Trailer MSE
        % Position
    xQMSEloss = sum((x_ref - xQ).^2)/6001;
    yQMSEloss = sum((y_ref - yQ).^2)/6001;
    QMSEloss_pos = xQMSEloss + yQMSEloss;
    QMSEK_pos = cat(2, QMSEK_pos, QMSElossK_pos);
    QMSEKNN_pos = cat(2, QMSEKNN_pos, QMSEloss_pos);
    
        % Velocities
    vQMSEloss = sum((vref - vQ).^2)/6001;
    wQMSEloss = sum((wref - wQ).^2)/6001;
    QMSEloss_vel = vQMSEloss + wQMSEloss;
    QMSEK_vel = cat(2, QMSEK_vel, QMSElossK_vel);
    QMSEKNN_vel = cat(2, QMSEKNN_vel, QMSEloss_vel);
    
    % Robot MSE
        % Position
    xPMSEloss = sum((x_ref - xP).^2)/6001;
    yPMSEloss = sum((y_ref - yP).^2)/6001;
    PMSEloss_pos = xPMSEloss + yPMSEloss;
    PMSEK_pos = cat(2, PMSEK_pos, PMSElossK_pos);
    PMSEKNN_pos = cat(2, PMSEKNN_pos, PMSEloss_pos);
    
        % Velocity
    vPMSEloss = sum((vref - vP).^2)/6001;
    wPMSEloss = sum((wref - wP).^2)/6001;
    PMSEloss_vel = vPMSEloss + wPMSEloss;
    PMSEK_vel = cat(2, PMSEK_vel, PMSElossK_vel);
    PMSEKNN_vel = cat(2, PMSEKNN_vel, PMSEloss_vel);
    

    % Simulated Annealing
%     if i > 3
%         diff_PMSE = PMSEKNN_vel(i)-PMSEKNN_vel(i-1);
%         diff_QMSE = QMSEKNN_vel(i)-QMSEKNN_vel(i-1);
% 
%         if diff_PMSE < 0.05*PMSE(i) && diff_QMSE < 0.05*QMSE(i)
%             W1_out(:,:, end) = W1_out(:,:, end) + 0.1*coeff_rand*rand(size(W1_out, 1), size(W1_out, 2));
%             W2_out(:,:, end) = W2_out(:,:, end) + 0.1*coeff_rand*rand(size(W2_out, 1), size(W2_out, 2));
%             W3_out(:,:, end) = W3_out(:,:, end) + 0.1*coeff_rand*rand(size(W3_out, 1), size(W3_out, 2));
%             W4_out(:,:, end) = W4_out(:,:, end) + 0.1*coeff_rand*rand(size(W4_out, 1), size(W4_out, 2));
%         end
%     end
        
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

    disp(i)
    
end