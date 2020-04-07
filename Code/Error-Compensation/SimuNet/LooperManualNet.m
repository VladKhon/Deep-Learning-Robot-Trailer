clc;
clear all;
sim('config5sim_KinematicController.slx');

for i = 1:100
    if i == 1
        W_i = 0.1*rand(1, 18);    
    else
        W_i = W_out(end,:);
    end
    wref(2) = 0;
    wQ(2) = 0;
    sim('config5sim_KinematicController_NNCedManualNet.slx');
    disp(i)
end

% vref_min = min(vref);
% vref_max = max(vref);
% wref_min = min(wref);
% wref_max = max(wref);
% vQ_min = min(vQ);
% vQ_max = max(vQ);
% wQ_min = min(wQ);
% wQ_max = max(wQ);
% vref_rng = vref_max - vref_min;
% wref_rng = wref_max - wref_min;
% vQ_rng = vQ_max - vQ_min;
% wQ_rng = wQ_max - wQ_min;  

