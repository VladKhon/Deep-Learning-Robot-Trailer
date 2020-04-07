%% Simulation script for TTMR
% Prerequisites:
%   1. Configure the robot parameters component (mass, position, and
%   dimensions) at 'roboparam.m'
% Procedure:
%   1. Set initial states using variable z0, check the state numbers
%   accordingly if 0 is 1not the initial values. Note: the variable must be
%   a column vector.
%   2. Set the simulation time (t0, tint, tf), initial, increments and
%   final
% Outputs:
%   tau1, tau2 -> Torques
%   x, y, th1, th0 -> States
%% Simulation
% Initialize the work space

close all;
clear all;
clc;

%% Simulation variables, parameters, and options
environment = 1; % 1 for S shape, 2 for N shape, 3 for SNS shape
test_path = 1; % Same as above but sets that which to predict on
activate_environment = 0;
dataset_size = 300;
MSE_lim = 150; % path rejection criteria for dataset generation

roboparam;  % Lists the robot parameters necessary for the simulation

t0 = 0;             % initial time
tint = 0.025;       % time increments
tf = 80;            % final time
t = t0:tint:tf;     % time vector

%% Dataset Generation
global set_path;
MSE = [];
for i = 1:dataset_size
%     if i == 1
%         set_path = 1;
%     elseif i == dataset_size
%         set_path = 3;
%     else
%         randomiser = 1+int16(2*rand);
%         set_path = randomiser; 
%     end
    set_path = 1;
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
        tau1out = tau1;
        tau2out = tau2;
    else
        if MSE_loss > MSE_lim
            continue
        end
        xout = cat(2, xout, xP);
        yout = cat(2, yout, yP);
        th1out = cat(2, th1out, th(:,1));
        th0out = cat(2, th0out, th(:,2));
        tau1out = cat(2, tau1out, tau1);
        tau2out = cat(2, tau2out, tau2);
    end
end

% Variable Saving
csvwrite('Datasets_Dynamics/1env/x.csv', xout);
csvwrite('Datasets_Dynamics/1env/y.csv', yout);
csvwrite('Datasets_Dynamics/1env/th1.csv', th1out);
csvwrite('Datasets_Dynamics/1env/th0.csv', th0out);
tau = [tau1out, tau2out];
csvwrite('Datasets_Dynamics/1env/tau.csv', tau);

%% Python Calling and Deep Learning
% Disclaimer: 
% Please be sure to have numpy, pandas, matplotlib, and Tensorflow 2.0 
% installed to Python3.7.
% system('python3 ControlRNN_Dynamics.py')

%% Prediction Plotting
tloc = t0:tint:tf;
S0 = [0 0];
S = csvread('Datasets_Dynamics/PredictedTorques.csv');
S = vertcat(S0, S);
tau1 = [t' S(:, 1)];
tau2 = [t' S(:, 2)];
sim('AXON_Dynamics_CONF5.slx')
%% Visualization Purposes
pause(1)
% Figure 2
figure(2);
for i=1:length(tloc)-1
    hold on
    Px = xP(i);
    Py = yP(i);
    th1 = th(i,1);
    th0 = th(i,2);
    
    %T0Q = [rotz(th1*180/pi) [Qx; Qy; 0]; 0 0 0 1];
    TOP = [rotz((th1)*180/pi) [Px; Py; 0]; 0 0 0 1];
    TPM = [eye(3) [rho1; 0; 0]; 0 0 0 1];
    b = TOP*[rho1; 0; 0; 1];
    Mx = b(1);
    My = b(2);
    
    TMQ = [rotz((th1-th0)*180/pi) [rho0*cos(th0-th1); rho0*sin(th0-th1); 0]; 0 0 0 1];
    a = TOP*TPM*TMQ;
   
    Qx(i) = a(1,4);
    Qy(i) = a(2,4);
      
    if(mod(i,20)==1)
        clf;
        hold on;
        ylim=10;
        xlim=-10;
        text(xlim(1),ylim(1),['time = ' num2str(tloc(i))])
        axis([0 30 -5 25])
        
        % direction "heading"
        u1 = cos(th0);
        u2 = sin(th0);
        quiver(Qx(i),Qy(i),u1,u2,'LineWidth',2)
        
        % Links Position Q -> axqon, P -> troplley
        lx = [Qx(i) Mx Px];
        ly = [Qy(i) My Py];
        h1 = plot(lx, ly,'bo-');
        text(Qx(i), Qy(i)+0.3,'axon')
        text(Px,Py+0.3,'cart')
        
        % Warehouse environment
        gen_environment(set_path)

        axis square
        pause(0.001);
    end
end

h1 = plot(xy_trolley.DATA(:,1),xy_trolley.DATA(:,2),'.-');
h2 = plot(Qx,Qy,'.-g');
legend([h1,h2],'Cart Path','Axon Path')
legend([h1,h2],'Axon Path','Cart Path')