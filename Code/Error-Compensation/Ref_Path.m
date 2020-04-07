% figure(2); clf; hold on;
% axis([0 25 -12 12])
% plot([0 10],[2 2],'-k')
% plot([10 10],[2 12],'-k')
% plot([0 14],[-2 -2],'-k')
% plot([14 14],[-2 8],'-k')
% plot([10 25],[12 12],'-k')
% plot([14 25],[8 8],'-k')

t = [0 20 30 50 60 80];
points = [0 0;
         10 0;
         12 2;
         12 8;
         14 10;
         24 10;] + (rand-rand);

x = points(:,1);
y = points(:,2);

tq = [0.0 : 0.01 : 80.0].';
slope0 = 0;
slopeF = 0;
xq = spline(t,[slope0; x; slopeF],tq);
yq = spline(t,[slope0; y; slopeF],tq);
xref = [tq xq];
yref = [tq yq];

% plot(x,y,'o',xq,yq,':.');
% axis equal;
% title('Reference Path');
