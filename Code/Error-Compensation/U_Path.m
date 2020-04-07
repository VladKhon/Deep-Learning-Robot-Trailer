% figure(2); clf; hold on;
% 
% plot([0, 4.5],[0 0],'k','linewidth',2)
% plot([0, 3],[-1.5, -1.5],'k','linewidth',2)
% plot([4.5, 4.5],[0, -3.5],'k','linewidth',2)
% plot([3.0, 3.0],[-1.5, -5],'k','linewidth',2)
% plot([4.5, 7],[-3.5, -3.5],'k','linewidth',2)
% plot([3.0, 8.5],[-5, -5],'k','linewidth',2)
% plot([7, 7],[-3.5, 0],'k','linewidth',2)
% plot([8.5, 8.5],[-5, -1.5],'k','linewidth',2)
% plot([7, 11.5],[0 0],'k','linewidth',2)
% plot([8.5, 11.5],[-1.5, -1.5],'k','linewidth',2)
% axis 'square'
% xlim([0 11.5])
t =  [0.0 6.5 13.375 19.875 26.75 33.25 40.125 46.625 53.5 60.0];
points = [0.0 -0.75;
     3.0 -0.75;
     3.75 -1.75;
     3.75 -3.25;
     4.5 -4.25;
     7.0 -4.25;
     7.75 -3.25;
     7.75 -1.75;
     8.5 -0.75;
     11.5 -0.75];
   
x = points(:,1);
y = points(:,2);


tq = [0.0 : 0.01 : 60.0].';
slope0 = 0;
slopeF = 0;
xq = spline(t,[slope0; x; slopeF],tq);
yq = spline(t,[slope0; y; slopeF],tq);
xref = [tq xq];
yref = [tq yq];


% plot(x,y,'o',xq,yq,':.');
% axis([0.0 11.5 -5.0 0.0]);
% axis equal;
% title('Reference Path');







