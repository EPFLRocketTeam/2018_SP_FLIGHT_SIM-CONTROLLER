clear; clf
point_1 = [1; 1];
degree_1 = 300; 
plot_subTriangulation(point_1, degree_1)

point_2 = [4; 3];
degree_2 = 60; 
plot_subTriangulation(point_2, degree_2)

point_3 = [1; 3];
degree_3 = 270; 
plot_subTriangulation(point_3, degree_3)

function plot_subTriangulation(point, degree)
%point: [x; y]
%degree: 0 = north; 90 = East; 180 = West; 270 = South;
line_point = [point(1) + cosd(90+degree); point(2) + sind(90+degree)];
line_point2 = [point(1) + 2 * cosd(90+degree); point(2) + 2 * sind(90+degree)];
plot([point(1), line_point(1)], [point(2), line_point(2)], '--b');
hold on;
plot(point(1), point(2), 'r*')
plot(line_point2(1), line_point2(2), 'g+')
end
