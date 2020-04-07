%% ODE function for the dynamics of TTMR that uses linear and angular velocity states
% t -> time variable
% z -> state variables  [x,y,th1,th0,psicw(4), v,w]

function [dz] = Kinematics(t,z) 
roboparam; % robot parameters set by 'roboparam.m' ( mass, position and dimensions as indicated by the configuration )

% variable state assignment n of pt P (x,y) axon orientation (th0) and trolley orientation (th1)
x = z(1);
y = z(2);
th1 = z(3);
th0 = z(4);

% ---Altered--- %
global V;
global W;
t = floor(t*10)/10;
pos = (t+0.1)/0.1;
v = V(int16(pos));
w = W(int16(pos));

% [v, w] = controlVr(t);
% ---Altered--- %

%% Config 5
%% Axon Kinematics
% dx, dy, dth1, dth0 -> change in position and orientation
dx = cos(th1)*cos(th1-th0)*v-cos(th1)*sin(th1-th0)*rho0*w;
dy = sin(th1)*cos(th1-th0)*v-sin(th1)*sin(th1-th0)*rho0*w;
dth1 = -sin(th1-th0)/rho1*v-(cos(th1-th0)*rho0)/rho1*w;
dth0 = w;
dz = [dx, dy, dth1, dth0].';

end

