% gen_environment(1)
global ideal
t = [0 20 30 50 60 80]; % [0 12 24 36 48 60];
if ideal == 1
    points = [1 0;
             10 0;
             12 2;
             12 8;
             14 10;
             24 10;];
else
    points = [1 0;
             10 0;
             12 2;
             12 8;
             14 10;
             24 10;] + [0 0; 0.8*(rand(4,2)-rand(4,2)); 0 0];
end

x = points(:,1);
y = points(:,2);

tq = [0.0 : 0.025 : 80.0].';
slope0 = 0;
slopeF = 0;
xq = spline(t,[slope0; x; slopeF],tq);
yq = spline(t,[slope0; y; slopeF],tq);
xref = [tq xq];
yref = [tq yq];

% plot(x,y,'o',xq,yq,':.');
% axis equal;
% title('Reference Path');
