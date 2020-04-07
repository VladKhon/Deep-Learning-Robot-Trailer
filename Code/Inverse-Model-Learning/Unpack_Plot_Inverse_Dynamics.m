%% Prediction Plotting
S0 = [0 0];
t0 = 0;         % initial time
tint = 0.025;   % time increments
tf = 80;        % final time

tloc = t0:tint:tf;

S = csvread('Datasets_Dynamics/1env/PredictedTorquesLatest.csv');
S = vertcat(S0, S);
tau1 = [tloc' S(:, 1)];
tau2 = [tloc' S(:, 2)];
global ideal;
ideal = 1
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
%         ylim=10;
%         xlim=-10;
%         text(xlim(1),ylim(1),['time = ' num2str(tloc(i))])
        axis([-5 25 -5 25])
        
        % direction "heading"
        u1 = cos(th0);
        u2 = sin(th0);
        quiver(Qx(i),Qy(i),u1,u2,'LineWidth',2)
        
        % Links Position Q -> axqon, P -> troplley
        lx = [Qx(i) Mx Px];
        ly = [Qy(i) My Py];
        h1 = plot(lx, ly,'bo-');
        text(Qx(i)+1, Qy(i)+0.3,'axon')
        text(Px,Py-0.6,'cart')
        
        % Warehouse environment
        gen_environment(1)

        axis equal
        pause(0.001);
    end
end
X_ref = csvread('Datasets_Dynamics/1env/x.csv');
Y_ref = csvread('Datasets_Dynamics/1env/y.csv');
x_ref = X_ref(:,end)
y_ref = Y_ref(:,end)

ref = plot(x_ref, y_ref,'--black')
h1 = plot(xP,yP,'.-r');
h2 = plot(Qx,Qy,'.-g');
legend([ref,h1,h2],'Reference Path','Axon Path','Cart Path')
xlabel('x-position');
ylabel('y-position');