%% ODE function for the dynamics of configuration 5 that uses linear and angular velocity states
% t -> time variable
% z -> state variables  [x,y,th1,th0,psicw(4), v,w]

function dz = AXON_Dynamics_CONF5_vw(t,z) 

% variable state assignment

% position of pt P (x,y) axon orientation (th0) and trolley orientation (th1)
x = z(1);
y = z(2);
th1 = z(3);
th0 = z(4);

% caster wheel orientation (psicw_i)
% psicw1 = z(5);
% psicw2 = z(6);
% psicw3 = z(7);
% psicw4 = z(8);

% YOUR INPUTS YOU FUCKTARD linear and angular velocity of and about point P (v,w)
v = 0;%z(9); SPEED 
w = 0.1;%z(10); HEADING

roboparam % robot parameters set by 'roboparam.m' ( mass, position and dimensions as indicated by the configuration )

T = rhoH/2*[1, 1; -1/L 1/L]; % transformation matrix for driving wheels to velocities[v;w] = T*dphiH

    dphi=inv(T)*[v;w];
    dphiH1 = dphi(1);   % driving wheels rotation rate (L)
    dphiH2 = dphi(2);   % driving wheels rotation rate (R)


%% Config 5
%% Axon Kinematics
% dx, dy, dth1, dth0 -> change in position and orientation
dx = cos(th1)*cos(th1-th0)*v-cos(th1)*sin(th1-th0)*rho0*w;
dy = sin(th1)*cos(th1-th0)*v-sin(th1)*sin(th1-th0)*rho0*w;
dth1 = -sin(th1-th0)/rho1*v-(cos(th1-th0)*rho0)/rho1*w;
dth0 = w;

%delthd = dth1 - dth0;
% 
% %% Trolley Kinematics
% % dPSIcw -> caster wheel swivel rate (change in caster wheel orientation)
% dpsicw1  = -(v*(2*s_w*sin(th1-th0)*sin(psicw1-th1)-s_l*sin(th1-th0)*cos(psicw1-th1)+2* ...
%     cos(th1)*cos(th1-th0)*rho1*sin(psicw1)-2*sin(th1)*cos(th1-th0)*rho1*cos(psicw1))+w*rho0*(2* ...
%     s_w*cos(th1-th0)*sin(psicw1-th1)-s_l*cos(th1-th0)*cos(psicw1-th1)-2*cos(th1)*sin(th1-th0)* ...
%     rho1*sin(psicw1)+2*sin(th1)*sin(th1-th0)*rho1*cos(psicw1)))/(2*dcw*rho1);
% 
% dpsicw2  = (v*(2*s_w*sin(th1-th0)*sin(psicw2-th1)+s_l*sin(th1-th0)*cos(psicw2-th1)-2* ...
%     cos(th1)*cos(th1-th0)*rho1*sin(psicw2)+2*sin(th1)*cos(th1-th0)*rho1*cos(psicw2))+w*rho0*(2* ...
%     s_w*cos(th1-th0)*sin(psicw2-th1)+s_l*cos(th1-th0)*cos(psicw2-th1)+2*cos(th1)*sin(th1-th0) ...
%     *rho1*sin(psicw2)-2*sin(th1)*sin(th1-th0)*rho1*cos(psicw2)))/(2*dcw*rho1);
% 
% dpsicw3  = -(v*(2*s_w*sin(th1-th0)*sin(psicw3-th1)+s_l*sin(th1-th0)*cos(psicw3-th1)+2* ...
%     cos(th1)*cos(th1-th0)*rho1*sin(psicw3)-2*sin(th1)*cos(th1-th0)*rho1*cos(psicw3))+w*rho0*(2* ...
%     s_w*cos(th1-th0)*sin(psicw3-th1)+s_l*cos(th1-th0)*cos(psicw3-th1)-2*cos(th1)*sin(th1-th0) ...
%     *rho1*sin(psicw3)+2*sin(th1)*sin(th1-th0)*rho1*cos(psicw3)))/(2*dcw*rho1);
% 
% dpsicw4  = (v*(2*s_w*sin(th1-th0)*sin(psicw4-th1)-s_l*sin(th1-th0)*cos(psicw4-th1)-2* ...
%     cos(th1)*cos(th1-th0)*rho1*sin(psicw4)+2*sin(th1)*cos(th1-th0)*rho1*cos(psicw4))+w*rho0*(2* ...
%     s_w*cos(th1-th0)*sin(psicw4-th1)-s_l*cos(th1-th0)*cos(psicw4-th1)+2*cos(th1)*sin(th1-th0) ...
%     *rho1*sin(psicw4)-2*sin(th1)*sin(th1-th0)*rho1*cos(psicw4)))/(2*dcw*rho1);
% 
% %% Dynamics: Mpp*d?/dt + npp*? + n3p*psiCW = Bpp*?
% %       ? = [v;w]; ? = [?1; ?2] 
%   
% Mpp = [[(2*IHy)/rhoH^2+(ITP*sin(th1-th0)^2)/rho1^2+mT*cos(th1-th0)^2 , (ITP*cos(th1-th0)*sin(th1-th0)*rho0)/rho1^2-mT*cos(th1-th0)*sin(th1-th0)*rho0]; ...
%     [(ITP*cos(th1-th0)*sin(th1-th0)*rho0)/rho1^2-mT*cos(th1-th0)*sin(th1-th0)*rho0, (2*IHy*L^2)/rhoH^2+(ITP*cos(th1-th0)^2*rho0^2)/rho1^2+mT*sin(th1-th0)^2*rho0^2-2*e2*rho0+ITz]];
% 
% npp = [[-(delthd*cos(th1-th0)*sin(th1-th0)*(mT*rho1^2-ITP))/rho1^2, -(delthd*rho0*(mT*cos(th1-th0)^2*rho1^2+ITP*sin(th1-th0)^2)+e2*(dth0)*rho1^2-e1*(dth1)*rho0*rho1)/rho1^2];...
%     [(delthd*rho0*(mT*sin(th1-th0)^2*rho1^2+ITP*cos(th1-th0)^2)+e2*(dth0)*rho1^2-e1*(dth1)*rho0*rho1)/rho1^2 , (delthd*cos(th1-th0)*sin(th1-th0)*rho0^2*(mT*rho1^2-ITP))/rho1^2]];
% 
% n3p = [[(dcw*mCW*(dpsicw1)*(s_l*sin(th1-th0)*sin(psicw1-th1)+2*cos(th1-th0)*rho1*cos(psicw1-th1)+2*s_w*sin(th1-th0)*cos(psicw1-th1)))/(2*rho1) , (dcw*mCW*(dpsicw2)*(s_l*sin(th1-th0)*sin(psicw2-th1)+2*cos(th1-th0)*rho1*cos(psicw2-th1)-2*s_w*sin(th1-th0)*cos(psicw2-th1)))/(2*rho1), ...
%     -(dcw*mCW*(dpsicw3)*(s_l*sin(th1-th0)*sin(psicw3-th1)-2*s_w*sin(th1-th0)*cos(psicw3-th1)-2*sin(th1)*cos(th1-th0)*rho1*sin(psicw3)-2*cos(th1)*cos(th1-th0)*rho1*cos(psicw3)))/(2*rho1) , -(dcw*mCW*(dpsicw4)*(s_l*sin(th1-th0)*sin(psicw4-th1)+2*s_w*sin(th1-th0)*cos(psicw4-th1)-2*sin(th1)*cos(th1-th0)*rho1*sin(psicw4)-2*cos(th1)*cos(th1-th0)*rho1*cos(psicw4)))/(2*rho1)];...
%     [(dcw*mCW*rho0*(dpsicw1)*(s_l*cos(th1-th0)*sin(psicw1-th1)-2*sin(th1-th0)*rho1*cos(psicw1-th1)+2*s_w*cos(th1-th0)*cos(psicw1-th1)))/(2*rho1) , (dcw*mCW*rho0*(dpsicw2)*(s_l*cos(th1-th0)*sin(psicw2-th1)-2*sin(th1-th0)*rho1*cos(psicw2-th1)-2*s_w*cos(th1-th0)*cos(psicw2-th1)))/(2*rho1), ...
%     -(dcw*mCW*rho0*(dpsicw3)*(s_l*cos(th1-th0)*sin(psicw3-th1)-2*s_w*cos(th1-th0)*cos(psicw3-th1)+2*sin(th1)*sin(th1-th0)*rho1*sin(psicw3)+2*cos(th1)*sin(th1-th0)*rho1*cos(psicw3)))/(2*rho1) , -(dcw*mCW*rho0*(dpsicw4)*(s_l*cos(th1-th0)*sin(psicw4-th1)+2*s_w*cos(th1-th0)*cos(psicw4-th1)+2*sin(th1)*sin(th1-th0)*rho1*sin(psicw4)+2*cos(th1)*sin(th1-th0)*rho1*cos(psicw4)))/(2*rho1)]];
% 
% Bpp = [[1/rhoH,1/rhoH];[-L/rhoH,L/rhoH]];
% 
% controlT % control torque input for the axon-trolley dynamics set by 'controlT.m'
% 
% % d?/dt -> equation for the solution of the linear and angular accelerations
% dvw = inv(Mpp)*(Bpp*tau - npp*[v;w] - n3p*[dpsicw1;dpsicw2;dpsicw3;dpsicw4]);
% dv = dvw(1);    % linear acceleration
% dw = dvw(2);    % angular acceleration
% 
% dz = [dx,dy,dth1,dth0, dpsicw1, dpsicw2, dpsicw3, dpsicw4, dv, dw].';
% 
% end
%
dz = [dx, dy, dth1, dth0].';

end

