%% Simulation script for TTMR
% Prerequisites:
%   1. Configure the robot parameters component (mass, position, and
%   dimensions) at 'roboparam.m'
%   2. Configure control velocities for the driving wheels left and right
%   at 'controlV.m'
% Procedure:
%   1. Set initial states using variable z0, check the state numbers
%   accordingly if 0 is not the initial values. Note: the variable must be
%   a column vector.
%   2. Set the simulation time (t0, tint, tf), initial, increments and
%   final
% Outputs: ( as applicable per configuration )
%   Fig1. Visualization of the trajectory vs running time
%   t -> simulation time
%   z -> states
%% Simulation
% Initialize the work space
close all;
clear all;
clc;
% roboparam;  % Lists the robot parameters necessary for the simulation
% simulation time
t0 = 0;         % initial time
tint = 0.025;    % time increments
tf = 80;        % final time
tloc = t0:tint:tf;
%% Path Generation and Plotting
sim('config5sim_KinematicController_generator.slx');

% [t,z] = ode45(@AXON_Dynamics_CONF5_vw_old, t, z0);

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
        plot([0 10],[2 2],'-k')
        plot([10 10],[2 12],'-k')
        plot([0 14],[-2 -2],'-k')
        plot([14 14],[-2 8],'-k')
        plot([10 25],[12 12],'-k')
        plot([14 25],[8 8],'-k')

        axis square
        pause(0.001);
    end
end

h1 = plot(xy_trolley.DATA(:,1),xy_trolley.DATA(:,2),'.-');
h2 = plot(Qx,Qy,'.-g');
legend([h1,h2],'Cart Path','Axon Path')
legend([h1,h2],'Axon Path','Cart Path')