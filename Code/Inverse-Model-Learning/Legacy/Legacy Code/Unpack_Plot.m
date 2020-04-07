clear all;
clc;

roboparam;

t0 = 0;         % initial time
tint = 0.025;   % time increments
tf = 80;        % final time

global V;
global W;
global TIME;
z0 = [0 0 0 0]';
t = t0:tint:tf;
t = t';
S0 = [0 0];
S = csvread('PredictedSpeeds.csv');
S = vertcat(S0, S);
V = S(:, 1)';
W = S(:, 2)';
[t,z] = ode45(@Kinematics, t, z0);
%% Visualization Purposes
% Figure 2
figure(2); hold on;
for i=1:size(t,1)-1
    
    Px = z(i,1);
    Py = z(i,2);
    th1 = z(i,3);
    th0 = z(i,4);
    
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
        xlim=-8;
        text(xlim(1),ylim(1),['time = ' num2str(t(i))])
        plot([-0 30],[0 0],'--k')
        plot([0 0],[-5 25],'--k')
        
        % Warehouse environment
        plot([0 10],[2 2],'-k')
        plot([10 10],[2 12],'-k')
        plot([0 14],[-2 -2],'-k')
        plot([14 14],[-2 8],'-k')
        plot([10 25],[12 12],'-k')
        plot([14 25],[8 8],'-k')
        
        % direction "heading"
        u = cos(th0);
        v = sin(th0);
        quiver(Qx(i),Qy(i),u,v,'LineWidth',2)
        
        % Links Position Q -> axqon, P -> troplley
        lx = [Qx(i) Mx Px];
        ly = [Qy(i) My Py];
        h1 = plot(lx, ly,'bo-');
        text(Qx(i), Qy(i)+0.3,'axon')
        text(Px,Py+0.3,'cart');
        
        axis square
        pause(0.01);
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