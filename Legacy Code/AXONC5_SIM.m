%% Simuation script for Configuration 5 SUCK A DICK IM HIJACKING THIS CODE
% Prerequisites:
%   1. Configure the robot parameters component (mass, position, and
%   dimensions) at 'roboparam.m'
%   2. Configure control rotations for the driving wheels left and right
%   at 'controlT.m'
% Procedure:
%   1. Set initial states using variable z0, check the state numbers
%   accordingly if 0 is not the initial values. Note: the variable must be
%   a column vector.
%   2. Set the simulation time (t0, tint, tf), initial, increments and
%   final
% Outputs: ( as applicable per configuration )
%   Fig1. Visualization of the trajectory vs running time
%   Fig2. Trjectory from initial to final points
%   Fig3. Variable evolution vs time (dphiH and v,w)
%   Fig4. Variable evolution vs time (theta, psi, dpsi)
%   t -> simulation time
%   z -> states
% NOTE: Plots generated can be modified accordingly at PLOTS.m or as
% necessary by using the variables generated by the simulation

%% Simulation
% Initialize the work space
clear;
clc;
roboparam;  % Lists the robot parameters necessary for the simulation

% initial states
z0 = zeros(1,4)';

% simulation time
t0 = 0;         % initial time
tint = 0.01;    % time increments
tf = 100;       % final time

t=t0:tint:tf;

[t,z] = ode45(@AXON_Dynamics_CONF5_vw,t, z0);
%[t,z] = ode45(@AXON_Dynamics_CONF2_phi,t, z0);

%% Visualization Purposes
% Figure 1
figure(1); hold on;
for i=1:size(t,1)-1
    
    Px=z(i,1);
    Py=z(i,2);
    th1 = z(i,3);
    th0 = z(i,4);
    
    %T0Q = [rotz(th1*180/pi) [Qx; Qy; 0]; 0 0 0 1];
    TOP = [rotz(th1*180/pi) [Px; Py; 0]; 0 0 0 1];
    TPM = [eye(3) [rho1; 0; 0]; 0 0 0 1];
    a = TOP*[rho1; 0; 0; 1];
    Mx = a(1);
    My = a(2);
    
    TMQ = [rotz((th1-th0)*180/pi) [rho0; 0; 0]; 0 0 0 1];
    a = TOP*TPM*TMQ;
    
    Qx(i,:) = a(1,4);
    Qy(i,:) = a(2,4);
    
    if(mod(i,20)==1)
        clf;
        hold on;
        ylim=10;
        xlim=-8;
        text(xlim(1),ylim(1),['time = ' num2str(t(i))])
        plot([-10 10],[0 0],'--k')
        plot([0 0],[-10 10],'--k')
        
        % direction "heading"
        u = cos(th0);
        v = sin(th0);
        quiver(Qx(i,:),Qy(i,:),u,v,'LineWidth',2)
        
        % Links Position Q -> axon P -> trolley
        lx = [Qx(i) Mx Px];
        ly = [Qy(i) My Py];
        h1 = plot(lx, ly,'bo-');
        text(Qx(i),Qy(i)+0.3,'axon')
        text(Px,Py+0.3,'cart');
        
        axis square
        pause(0.001);
    end
end
pt1 = find(t>5);
pt2 = find(t>8.5);
pt3 = find(t>12);
h1 = plot(z(:,1),z(:,2),'.-');
h2 = plot(Qx,Qy,'.-g');
legend([h1,h2],'Cart Path','Axon Path')
legend([h1,h2],'Axon Path','Cart Path')
plot(Qx(pt1(1)),Qy(pt1(1)), 'o');
plot(Qx(pt2(1)),Qy(pt2(1)), 'o');
plot(Qx(pt3(1)),Qy(pt3(1)), 'o');

%SIDE NOTE YOU FUCKING IDIOT: ARE YOU SO THICK AS TO NOT SEE HOW THE TRAILER
%BODY ORIENTATES DIFFERENTLY TO THE AXON??? ITS FUCKING GETTING SPUN BY IT
%YOU SHIT.