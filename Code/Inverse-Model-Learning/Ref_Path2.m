%gen_environment(2);
global ideal
t = [0 10 20 30 50 60 80];
if ideal == 1
    points = [1 0;
             2 -2;
             2 -8;
             4 -10;
             18 -10;
             20 -8;
             20 0;] + [2 0];
else
    points = [-1 0;
             2 -2;
             2 -8;
             4 -10;
             18 -10;
             20 -8;
             20 0;]+ [2 0] + [0 0; 0.8*(rand(6,2)-rand(6,2))];
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

% plot(x,y,'o',xq,yq,':.');
% axis equal;
% title('Reference Path');