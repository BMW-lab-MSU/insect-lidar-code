r = 40;
azimuth_high = 5;
azimuth_low = 0;
elevation_high = -1;
elevation_low = -5.5;

[vertices.x1,vertices.y1,vertices.z1] = sph2cart(azimuth_low, elevation_high, r);
[vertices.x2,vertices.y2,vertices.z2] = sph2cart(azimuth_low, elevation_low, r);
[vertices.x3,vertices.y3,vertices.z3] = sph2cart(azimuth_high, elevation_low, r);
[vertices.x4,vertices.y4,vertices.z4] = sph2cart(azimuth_high, elevation_high, r);

vertices.x_zero = 0;
vertices.y_zero = 0;
vertices.z_zero = 0;

x1 = [vertices.x_zero vertices.x1 vertices.x1];
y1 = [vertices.y_zero vertices.y1 vertices.y2];
z1 = [vertices.z_zero vertices.z1 vertices.z2];

x2 = [vertices.x_zero vertices.x1 vertices.x1];
y2 = [vertices.y_zero vertices.y2 vertices.y3];
z2 = [vertices.z_zero vertices.z2 vertices.z2];

x3 = [vertices.x_zero vertices.x1 vertices.x1];
y3 = [vertices.y_zero vertices.y3 vertices.y3];
z3 = [vertices.z_zero vertices.z3 vertices.z4];

x4 = [vertices.x_zero vertices.x1 vertices.x1];
y4 = [vertices.y_zero vertices.y3 vertices.y1];
z4 = [vertices.z_zero vertices.z4 vertices.z4];

patch(x1,y1,z1,'g', 'FaceAlpha', .3);
patch(x2,y2,z2,'g', 'FaceAlpha', .3);
patch(x3,y3,z3,'g', 'FaceAlpha', .3);
patch(x4,y4,z4,'g', 'FaceAlpha', .3);
view(3)

xlabel('x');
ylabel('y');
zlabel('z');

