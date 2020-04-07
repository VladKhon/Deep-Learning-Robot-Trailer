%% CONFIG5 PARAMS

%Kinematic Controller Parameters
k1=3.0;
k2=3.5;
k3=5.5;

rho0 = 0.5;     % 0.5; 
rho1 = 1;       % distance in m

%AXON-Trolley Initial conditions
yref_trolley0=0;

xtrolley0= 0; %Trolley initial position
ytrolley0= 0;
th1=0*pi/180;
th0=0*pi/180;

th0_ref=0;
th1_ref=0;

psicw10=0;
psicw20=0;
psicw30=0;
psicw40=0;
phicw10=0;
phicw20=0;
phicw30=0;
phicw40=0;
v0=0;
w0=0;

xaxon0=xtrolley0+rho1*cos(th1)+rho0*cos(th0);
yaxon0=ytrolley0+rho1*sin(th1)+rho0*sin(th0);

L = 0.387/2;
s_l = 0.928;
s_w = 0.48;
dcw = 0.075;
dqpx = 0;  % distance bet q and P
dqcmBx = 0*0.648/4; % distance bet Q and Axon Centre of Mass
cw1x = -s_l/2;
cw1_x = cw1x;
cw3x =  s_l/2;
cw3_x = cw3x;
dpcmPx = 0; %s_l/2;

% mass in kg
mB = 50;
m_P = 150;
mH = 2;
mW = 0.7;
mCW = 5.0; 
mT = m_P + 2*mW + 2*mH + 2*mCW +mB;

% wheel radius and distances
rhoH = 0.075;
rho_h = rhoH;
rhow = 0.06;
rho_w = rhow;
rhocw = 0.05;
rho_cw = rhocw;

e1 = (2*mH + mB)*rho1 + dpcmPx*m_P - 2*mCW*s_l; % dqpx*m_P + 2*mCW*(cw3x + cw1x) + dqcmBx*mB;
e2 = (2*mH + mB)*rho0 + dqcmBx*mB;

IWy = (1/2)*mW*rho_w^2;
IWz = (1/12)*mW*(3*rho_w^2 + 0.03^2);
ICWz = (1/12)*mCW*(3*rho_cw^2 + 0.01^2);
IPz = (1/12)*m_P*(s_l^2 + (2*s_w)^2);
IBz = (1/12)*mB*(0.3^2 + 0.6^2);
IHz = (1/12)*mH*(3*rho_h^2 + 0.03^2);
IHy = (1/2)*mH*rho_h^2;

ITw = IWz + s_w^2*mW;
ITCWz = ICWz + mCW*dcw^2;
ITB = IBz + mB*dqcmBx^2;
ITH = IHz + mH*L^2;
IT_P = IPz + m_P*dpcmPx^2;

ITz = (2*mH + mB)*rho0^2 + 2*dqcmBx*mB*rho0 + ITB + 2*ITH;
ITP = (2*mH + mB)*rho1^2 + IT_P + 2*ITw + 2*mCW*(s_w^2 + s_l^2);

% LEGACY PARAMS
% Set Parameters of the robot-trailer system
% t -> time variable
% z -> state variables  [x,y,th1,th0,psicw(4), v,w]

% L = 0.1935;
% s_l = 0.920;
% s_w = 0.480;
% d_QcmB = 0.162;
% mB = 50;
% mp = 15;
% mh = 2;
% mCW = 0.7;
% mT = mB + 2*mh + mp + 4*mCW;
% dcw = 0.050;

% rhoH = 0.075;
% rhoW = 0.060;
% rhoCW = 0.050;
% rho0 = 0.5;
% rho1 = 1;
% 
% IHy = 1;
% ITP = 1;
% ITz = 1; 
% e1 = mB + 2*mB*rho1 + (L*mp)/2 + 2*L*mCW;
% e2 = (mB + 2*mh)/rho0 + d_QcmB/mB;