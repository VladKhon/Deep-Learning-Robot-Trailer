clc;
clear all;

t0 = 0;         % initial time
tint = 0.01;    % time increments
tf = 100;       % final time
t=t0:tint:tf;

xr = 2*t;
yr = 2*sin(t/4);
theta = atan2(yr,xr);
v = sqrt(2^2 + (-0.5*cos(t/4)).^2); % SPEED 
for i = 1:length(t)
    w(i) = (4*sin(t(i)/4) - cos(t(i)/4)*t(i))/(4*(t(i)^2 + sin(t(i)/4)^2));
end
w(1) = 0;