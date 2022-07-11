

[cart_sixteen.x cart_sixteen.y cart_sixteen.z]=sph2cart(deg2rad(scan_sixteen.pan),deg2rad(scan_sixteen.tilt),(scan_sixteen.distance));

[cart_seventeen.x cart_seventeen.y cart_seventeen.z]=sph2cart(deg2rad(scan_seventeen.pan),deg2rad(scan_seventeen.tilt),(scan_seventeen.distance))

[cart_eighteen.x cart_eighteen.y cart_eighteen.z]=sph2cart(deg2rad(scan_eighteen.pan),deg2rad(scan_eighteen.tilt),(scan_eighteen.distance))

[cart_twenty.x cart_twenty.y cart_twenty.z]=sph2cart(deg2rad(scan_twenty.pan),deg2rad(scan_twenty.tilt),(scan_twenty.distance))



close all
% figure(2);
% scatter3(cart_sixteen.x,cart_sixteen.y,scan_sixteen.distance,'*','r')
% hold on
% scatter3(cart_eighteen.x,cart_eighteen.y,scan_eighteen.distance,'o','r')
% scatter3(cart_seventeen.x,cart_seventeen.y,scan_seventeen.distance,'*','k')
% scatter3(cart_twenty.x,cart_twenty.y,scan_twenty.distance,'o','k')
% xlabel('x');
% %xlim([0 20])
% ylabel('y');
% %ylim([0 20])
% zlabel('distance');
% %zlim([0 20])

% figure(2)
% scatter3(scan_sixteen.pan,scan_sixteen.tilt,scan_sixteen.distance,'*','r');
% hold on
% scatter3(scan_eighteen.pan, scan_eighteen.tilt, scan_eighteen.distance, 'o','r');
% scatter3(scan_seventeen.pan,scan_seventeen.tilt, scan_seventeen.distance,'*', 'k');
% scatter3(scan_twenty.pan, scan_twenty.tilt, scan_twenty.distance,'o','k');
% xlabel('Pan Degrees');
% xlim([0 5])
% ylabel('Tilt Degrees');
% ylim([-5.5 -1]);
% zlabel('Distance (m)')
% zlim([0 20]);
% 
% 
% figure(3)
% scatter(scan_sixteen.pan,scan_sixteen.tilt,'*','r');
% hold on
% scatter(scan_eighteen.pan, scan_eighteen.tilt, 'o','r');
% scatter(scan_seventeen.pan,scan_seventeen.tilt, '*', 'k');
% scatter(scan_twenty.pan, scan_twenty.tilt, 'o','k');
% 
% figure(4)
% scatter(scan_sixteen.pan,scan_sixteen.distance,'*','r');
% hold on
% scatter(scan_eighteen.pan, scan_eighteen.distance, 'o','r');
% scatter(scan_seventeen.pan,scan_seventeen.distance, '*', 'k');
% scatter(scan_twenty.pan, scan_twenty.distance, 'o','k');
% ylim([0 15])
% xlabel('Pan Degrees');
% ylabel('Distance (m)');
% 
% 
% figure(1)
% scatter3(cart_sixteen.x,cart_sixteen.y,cart_sixteen.z,'*','r')
% hold on
% scatter3(cart_eighteen.x,cart_eighteen.y,cart_eighteen.z,'o','r')
% scatter3(cart_seventeen.x,cart_seventeen.y,cart_seventeen.z,'*','k')
% scatter3(cart_twenty.x,cart_twenty.y,cart_twenty.z,'o','k')
% xlabel('x');
% xlim([0 20])
% ylabel('y');
% ylim([0 1])
% zlabel('z');
% %zlim([0 20])
% 

r = 30;
azimuth_high = deg2rad(-6);
azimuth_low = 0;
elevation_high = deg2rad(-1);
elevation_low = deg2rad(5.5);

[vertices.x1,vertices.y1,vertices.z1] = sph2cart(azimuth_low, elevation_high, r);
[vertices.x2,vertices.y2,vertices.z2] = sph2cart(azimuth_low, elevation_low, r);
[vertices.x3,vertices.y3,vertices.z3] = sph2cart(azimuth_high, elevation_low, r);
[vertices.x4,vertices.y4,vertices.z4] = sph2cart(azimuth_high, elevation_high, r);

vertices.x_zero = 0;
vertices.y_zero = 0;
vertices.z_zero = 0;

x1 = [vertices.x_zero vertices.x1 vertices.x1];
z1 = [vertices.y_zero vertices.y1 vertices.y2];
y1 = [vertices.z_zero vertices.z1 vertices.z2];

x2 = [vertices.x_zero vertices.x1 vertices.x1];
z2 = [vertices.y_zero vertices.y2 vertices.y3];
y2 = [vertices.z_zero vertices.z2 vertices.z2];

x3 = [vertices.x_zero vertices.x1 vertices.x1];
z3 = [vertices.y_zero vertices.y3 vertices.y3];
y3 = [vertices.z_zero vertices.z3 vertices.z4];

x4 = [vertices.x_zero vertices.x1 vertices.x1];
z4 = [vertices.y_zero vertices.y3 vertices.y1];
y4 = [vertices.z_zero vertices.z4 vertices.z4];

hold on
scatter3(cart_sixteen.x,cart_sixteen.y,cart_sixteen.z,'o','r','MarkerFaceColor', 'r');
scatter3(cart_seventeen.x,cart_seventeen.y,cart_seventeen.z,'o','k','MarkerFaceColor', 'k');
scatter3(cart_eighteen.x,cart_eighteen.y,cart_eighteen.z,'o','r','MarkerFaceColor', 'r');
scatter3(cart_twenty.x,cart_twenty.y,cart_twenty.z,'o','k','MarkerFaceColor', 'k');

patch(x1,y1,z1,'g', 'FaceAlpha', .3);
patch(x2,y2,z2,'g', 'FaceAlpha', .3);
patch(x3,y3,z3,'g', 'FaceAlpha', .3);
patch(x4,y4,z4,'g', 'FaceAlpha', .3);
patch([11.55 30 30 11.55], [-0.2 -0.55 2.87 1.1], [-1.2 -1.2 -1.2 -1.2], 'k') % Ground plane, if you want it
%patch([0 50 50 0], [0 0 4 4], [-1.2 -1.2 -1.2 -1.2], 'b') % Ground plane, if you want it
view(3)

xlabel('x');
ylabel('y');
zlabel('z');

line([12 12],[0.45 0.45], [-1.2 1],'LineWidth', 3, 'Color', 'r');

box on
zlim([-1.2 0]);
ylim([-5 5]);
xlim([0 25]);

% Center = [12,0.5, 0.5] ;   % center of circle 
% Rad = 1. ;    % Radius of circle 
% teta=0:0.01:2*pi ;
% xx=Center(1)+Rad*cos(teta);
% yy=Center(2)+Rad*sin(teta) ;
% zz = Center(3)+zeros(size(xx)) ;
% patch(xx,yy,zz,'r')
% 


% xlim([0 25])
% xlabel('x'); ylabel('y');zlabel('z');
% ylim([-5 10])
% zlim([-10.5 4])
% 
% y1=linspace(0,5);
% y2=linspace(0,0);
% x1=linspace(-5.5,-5.5);
% x2=linspace(-5.5,-1);
% z=linspace(0,25);

% line(x1,y1,z);
% line(x1,y2,z);
% line(x2,y1,z);
% line(x2,y2,z);