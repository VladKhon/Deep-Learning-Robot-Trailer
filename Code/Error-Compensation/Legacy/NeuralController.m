clear all;
clc;

%% Initialize Dataset

dataset_size = 20;
disp('Creating Dataset')
for i = 1:dataset_size
    sim('config5sim_KinematicController_MNN')
    X_train{i,:} = [vref'; wref'; vout'; wout'];
    Y_train{i,:} = [vPcmd'; wPcmd'];
end

% disp('Creating Dataset')
% for i = 1:dataset_size
%     sim('config5sim_KinematicController_MNN')
%     if i == 1
%         Vref = vref';
%         Wref = wref';
%         Vout = vout';
%         Wout = wout';
%         VPcmd = vPcmd';
%         WPcmd = wPcmd';
%     else
%         Vref = cat(3, Vref, vref');
%         Wref = cat(3, Wref, wref');
%         Vout = cat(3, Vout, vout');
%         Wout = cat(3, Wout, wout');
%         VPcmd = cat(3, VPcmd, vPcmd');
%         WPcmd = cat(3, WPcmd, wPcmd');
%     end
% end

disp('Dataset Generated')
% % Data Preparation
% V_error = Vref - Vout;
% W_error = Wref - Wout;
% X_train = [Vref; Wref; V_error; W_error;];
% Y_train = [VPcmd; WPcmd]; %WPcmd];
X = X_train{1};

% Model

layers = [
    sequenceInputLayer(4,"Name","sequence")
    lstmLayer(6,"Name","lstm_1")
    lstmLayer(6,"Name","lstm_2")
    fullyConnectedLayer(2,"Name","fc")
    regressionLayer("Name", "regressionoutput")
    ];

% Hyperparameters
options = trainingOptions('adam', ...
    'MaxEpochs', 100, ...
    'InitialLearnRate', 0.05, ...
    'Plots', 'training-progress');

model = trainNetwork(X_train, Y_train, layers, options);
Y_pred = predict(model, X);

save('model.mat', 'model');

plot(tq, Y_pred(1,:), 'r-', tq, Y_pred(2,:), 'b-');
title('Predicted');