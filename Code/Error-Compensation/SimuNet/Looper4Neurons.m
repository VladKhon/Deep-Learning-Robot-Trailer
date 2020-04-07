clc;
clear all;
sim('config5sim_KinematicController.slx');
disp('Start')
for i = 1:500
    if i == 1
        W_i = 0.01*rand(1, 35);    
    else
        W_i = W_out(end,:);
    end
    sim('config5sim_KinematicController_NNCedManualNetH1N4_H2N3.slx');
    disp(i)
end