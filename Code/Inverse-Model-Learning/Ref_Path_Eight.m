figure(1); clf; hold on;
axis([0 25 -2 23])
axis equal
plot([0 0],[2 12],'-k')
plot([4 4],[2 8],'-k')
plot([0 22],[12 12],'-k')
plot([4 18],[8 8],'-k')
plot([22 22],[12 2],'-k')
plot([18 18],[8 2],'-k')

t = [0 10 20 30 40 50 60 70 80];
global ideal;
ideal = 1;
if ideal == 1
    points = [4*sin(0.2*t)' 4*sin(0.10*t)'];
else
    points = [2 2;
             2 8;
             4 10;
             18 10;
             20 8;
             20 0;] + [0.8*(rand(6,2)-rand(6,2))];
end
x = points(:,1);
y = points(:,2);

tq = [0.0 : 0.01 : 80.0].';
slope0 = 0;
slopeF = 0;
xq = spline(t,[slope0; x; slopeF],tq);
yq = spline(t,[slope0; y; slopeF],tq);
xref = [tq xq];
yref = [tq yq];

plot(x,y,'o',xq,yq,':.');
axis equal;
title('Reference Path');
