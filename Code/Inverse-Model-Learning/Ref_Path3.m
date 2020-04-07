% gen_environment(3)
global ideal
t = [0 8 16 24 32 40 48 56 64 72 80];
if ideal == 1
    points = [1 0;
             10 0;
             12 2;
             12 8;
             14 10;
             19.5 10;
             25 10;
             27 8;
             27 2;
             29 0;
             39 0];
else
    points = [1 0;
             10 0;
             12 2;
             12 8;
             14 10;
             19.5 10;
             25 10;
             27 8;
             27 2;
             29 0;
             39 0] + [0 0; 0.8*(rand(9,2)-rand(9,2)); 0 0];
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
