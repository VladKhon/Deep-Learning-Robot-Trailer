clc;
clear all;

for i = 1:20
    if i == 1
        Wy_latest = [0 0 0; 0 0 0];
        Wx_latest = [0 0 0; 0 0 0];
    end
    sim('config5sim_KinematicController_NNCedBPMN.slx')
    disp(i)
end