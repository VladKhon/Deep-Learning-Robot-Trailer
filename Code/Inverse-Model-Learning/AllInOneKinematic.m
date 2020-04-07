%% Simulation script for TTMR
% Prerequisites:
%   1. Configure the robot parameters component (mass, position, and
%   dimensions) at 'roboparam.m'
% Procedure:
%   1. Set initial states using variable z0, check the state numbers
%   accordingly if 0 is not the initial values. Note: the variable must be
%   a column vector.
%   2. Set the simulation time (t0, tint, tf), initial, increments and
%   final
% Outputs
%   v, w -> Speeds
%   x, y, th1, th0 -> States
%% Simulation
% Initialize the work space

close all;
clear all;
clc;

%% Simulation variables, parameters, and options
activate_environment = 0;
dataset_size = 600;
MSE_lim = 150; % path rejection criteria for dataset generation

roboparam;  % Lists the robot parameters necessary for the simulation

% simulation time
t0 = 0;         % initial time
tint = 0.025;     % time increments
tf = 80;        % final time

t = t0:tint:tf;

%% Dataset Generation
global set_path;
MSE = [];
for i = 1:dataset_size
    if i == 1
        set_path = 1;
    elseif i == dataset_size
        set_path = 3;
    else
        randomiser = 1+int16(2*rand);
        set_path = randomiser; 
    end
    if activate_environment == 1
        gen_environment(set_path);
    end
    sim('config5sim_KinematicController_generator.slx');
    MSE_loss = sum((1/2)*((x_ref-xP).^2 + (y_ref-yP).^2));
    MSE = cat(2, MSE, MSE_loss);
    figure(4)
    plot([0:i-1], MSE, '-or');
    axis([0 inf 0 inf])
    if i == 1
        if MSE_loss > MSE_lim
            continue
        end
        xout = xP;
        yout = yP;
        th1out = th(:,1);
        th0out = th(:,2);
        Vout = vQ;
        Wout = wQ;
    else
        if MSE_loss > MSE_lim
            continue
        end
        xout = cat(2, xout, xP);
        yout = cat(2, yout, yP);
        th1out = cat(2, th1out, th(:,1));
        th0out = cat(2, th0out, th(:,2));
        Vout = cat(2, Vout, vQ);
        Wout = cat(2, Wout, wQ);
    end
end

% Variable Saving
csvwrite('Datasets_Kinematics/x.csv', xout);
csvwrite('Datasets_Kinematics/y.csv', yout);
csvwrite('Datasets_Kinematics/th1.csv', th1out);
csvwrite('Datasets_Kinematics/th0.csv', th0out);
Vw = [Vout, Wout];
csvwrite('Datasets_Kinematics/Vw.csv', Vw);