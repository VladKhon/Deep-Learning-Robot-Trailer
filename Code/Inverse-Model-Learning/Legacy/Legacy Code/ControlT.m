%% Use this to input Torques to the drive motors of the robot
function [tau1, tau2] = ControlT(t)

    sim('config5sim_KinematicController.slx');
    
    tau1 = tau1;
    tau2 = tau2; 
end