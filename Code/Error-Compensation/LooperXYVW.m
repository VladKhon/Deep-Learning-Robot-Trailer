clc;
clear all;
sim('config5sim_KinematicController.slx');
disp('Start')

% Trailer MSE
xQMSElossK = sum((x_ref - xQ).^2)/6001;
yQMSElossK = sum((y_ref - yQ).^2)/6001;
QMSElossK = xQMSElossK + yQMSElossK;

% Robot MSE
xPMSElossK = sum((x_ref - xP).^2)/6001;
yPMSElossK = sum((y_ref - yP).^2)/6001;
PMSElossK = xPMSElossK + yPMSElossK;

PMSE = [];
QMSE = [];
PMSEK = [];
QMSEK = [];

In = 4;
H1 = 7;
H2 = 5;
H3 = 4;
Out = 2;
coeff_rand = 0.2;

for i = 1:100
    if i == 1
        W1_i = coeff_rand*(rand(H1,In+1) - rand(H1,In+1));
        W2_i = coeff_rand*(rand(H2,H1+1) - rand(H2, H1+1));
        W3_i = coeff_rand*(rand(Out, H2+1) - rand(Out, H2+1));
        %W4_i = coeff_rand*(rand(Out, H3+1) - rand(Out, H3+1));
    else
        W1_i = W1_out(:,:, end);
        W2_i = W2_out(:,:, end);
        W3_i = W3_out(:,:, end);
        %W4_i = W4_out(:,:, end); 
    end
    sim('config5sim_KinematicController_XYVW_NetFunc.slx');

    % Trailer MSE
    xQMSEloss = sum((x_ref - xQ).^2)/6001;
    yQMSEloss = sum((y_ref - yQ).^2)/6001;
    QMSEloss = xQMSEloss + yQMSEloss;

    % Robot MSE
    xPMSEloss = sum((x_ref - xP).^2)/6001;
    yPMSEloss = sum((y_ref - yP).^2)/6001;
    PMSEloss = xPMSEloss + yPMSEloss;

    PMSE = cat(2, PMSE, PMSEloss);
    QMSE = cat(2, QMSE, QMSEloss);

    PMSEK = cat(2, PMSEK, PMSElossK);
    QMSEK = cat(2, QMSEK, QMSElossK);
    
    % Simulated Annealing
%     if i > 3
%         diff_xMSE = xMSE(i)-xMSE(i-1);
%         diff_yMSE = yMSE(i)-yMSE(i-1);
%         diff_vMSE = vMSE(i)-vMSE(i-1);
%         diff_wMSE = wMSE(i)-wMSE(i-1);
% 
%         if diff_xMSE < 100 && diff_yMSE < 100
%             W1_out(:,:, end) = W1_out(:,:, end) + 0.1*coeff_rand*rand(size(W1_out, 1), size(W1_out, 2));
%             W2_out(:,:, end) = W2_out(:,:, end) + 0.1*coeff_rand*rand(size(W2_out, 1), size(W2_out, 2));
%             W3_out(:,:, end) = W3_out(:,:, end) + 0.1*coeff_rand*rand(size(W3_out, 1), size(W3_out, 2));
%         end
%     end
        
    figure(2)
    subplot(2,1,1)
    plot([0:i-1],QMSEK,'-r')
    hold on
    plot([0:i-1],QMSE,'-b')
    legend('Kinematic Robot', 'K + NN Robot')
    xlabel('Epochs')
    ylabel('MSEloss (X + Y total)')

    subplot(2,1,2)
    plot([0:i-1],PMSEK,'-r')
    hold on
    plot([0:i-1],PMSE,'-b')
    legend('Kinematic Trailer', 'K + NN Trailer')
    xlabel('Epochs')
    ylabel('MSEloss (X + Y total)')
    disp(i)
end
