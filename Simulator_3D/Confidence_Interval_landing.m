%% montecarlo 3D

% Initialize
close all; clear all;
addpath(genpath('../Declarations'),...
        genpath('../Functions'),...
        genpath('../Snippets'),...
        genpath('../Simulator_1D'));

% Rocket Definition
n_sim = 5;
Rocket_0 = rocketReader('BL_H4.txt');
SimOutputs = SimOutputReader('Simulation/Simulation_outputs.txt');
coordsx = 1:n_sim;
coordsy = 1:n_sim;
for i = 1 : n_sim
    x = ones(4,1);
    a = normrnd(x,0.03);
    Rocket = setfield(Rocket_0, 'CD_fac' , a(1));
    Rocket = setfield(Rocket, 'CNa_fac' , a(2));
    Rocket = setfield(Rocket, 'cp_fac' , a(3));
    Rocket = setfield(Rocket, 'motor_fac' , a(4));
    Environment = environnementReader('Environment/Environnement_Definition_Meringen.txt');
    SimObj = multilayerwindSimulator3D(Rocket, Environment, SimOutputs);
    [T1, S1] = SimObj.RailSim();
    [T2_1, S2_1, T2_1E, S2_1E, I2_1E] = SimObj.FlightSim([T1(end) SimObj.Rocket.Burn_Time(end)], S1(end, 2));
    [T2_2, S2_2, T2_2E, S2_2E, I2_2E] = SimObj.FlightSim([T2_1(end) 40], S2_1(end, 1:3)', S2_1(end, 4:6)', S2_1(end, 7:10)', S2_1(end, 11:13)');
    T2 = [T2_1; T2_2(2:end)];
    S2 = [S2_1; S2_2(2:end, :)];

    T_1_2 = [T1;T2];
    S_1_2 = [S1;S2(:,3) S2(:,6)];
    [T3, S3, T3E, S3E, I3E] = SimObj.DrogueParaSim(T2(end), S2(end,1:3)', S2(end, 4:6)');
    [T4, S4, T4E, S4E, I4E] = SimObj.MainParaSim(T3(end), S3(end,1:3)', S3(end, 4:6)');
    coordsx(i)=S4(end,1);  
    coordsy(i)=S4(end,2);
end

%please look at https://www.visiondummy.com/2014/04/draw-error-ellipse-representing-covariance-matrix/
% Create some random data
y1 = coordsx;
y2 = coordsy;
data = [y1.' y2.'];

% Calculate the eigenvectors and eigenvalues
covariance = cov(data);
[eigenvec, eigenval ] = eig(covariance);

% Get the index of the largest eigenvector
[largest_eigenvec_ind_c, r] = find(eigenval == max(max(eigenval)));
largest_eigenvec = eigenvec(:, largest_eigenvec_ind_c);

% Get the largest eigenvalue
largest_eigenval = max(max(eigenval));

% Get the smallest eigenvector and eigenvalue
if(largest_eigenvec_ind_c == 1)
    smallest_eigenval = max(eigenval(:,2));
    smallest_eigenvec = eigenvec(:,2);
else
    smallest_eigenval = max(eigenval(:,1));
    smallest_eigenvec = eigenvec(1,:);
end

% Calculate the angle between the x-axis and the largest eigenvector
angle = atan2(largest_eigenvec(2), largest_eigenvec(1));

% This angle is between -pi and pi.
% Let's shift it such that the angle is between 0 and 2pi
if(angle < 0)
    angle = angle + 2*pi;
end

% Get the coordinates of the data mean
avg = mean(data);

% Get the 95% confidence interval error ellipse
chisquare_val = 2.4477;
theta_grid = linspace(0,2*pi);
phi = angle;
X0=avg(1);
Y0=avg(2);
a=chisquare_val*sqrt(largest_eigenval);
b=chisquare_val*sqrt(smallest_eigenval);

% the ellipse in x and y coordinates 
ellipse_x_r  = a*cos( theta_grid );
ellipse_y_r  = b*sin( theta_grid );

%Define a rotation matrix
R = [ cos(phi) sin(phi); -sin(phi) cos(phi) ];

%let's rotate the ellipse to some angle phi
r_ellipse = [ellipse_x_r;ellipse_y_r]' * R;

% Get the 99.99% confidence interval error ellipse
chisquare_val1 = 4.29;
a1=chisquare_val1*sqrt(largest_eigenval);
b1=chisquare_val1*sqrt(smallest_eigenval);

% the ellipse in x and y coordinates 
ellipse_x_r1  = a1*cos( theta_grid );
ellipse_y_r1  = b1*sin( theta_grid );

%let's rotate the ellipse to some angle phi
r_ellipse1 = [ellipse_x_r1;ellipse_y_r1]' * R;


% Draw the error ellipse
%plot3(r_ellipse(:,1) + X0,r_ellipse(:,2) + Y0,0*r_ellipse(:,2),'-')
%hold on;

% Plot the original data
%plot3(data(:,1), data(:,2),0*data(:,2) ,'.');
%mindata = min(min(data));
%maxdata = max(max(data));
%xlim([mindata-3, maxdata+3]);
%ylim([mindata-3, maxdata+3]);
%hold on;

% Plot the eigenvectors
%quiver(X0, Y0, largest_eigenvec(1)*sqrt(largest_eigenval), largest_eigenvec(2)*sqrt(largest_eigenval), '-m', 'LineWidth',2);
%quiver(X0, Y0, smallest_eigenvec(1)*sqrt(smallest_eigenval), smallest_eigenvec(2)*sqrt(smallest_eigenval), '-g', 'LineWidth',2);
%hold on;

% Set the axis labels
%hXLabel = xlabel('x');
%hYLabel = ylabel('y');
% 1 is for no noise in layer.
Environment = environnementReader('Environment/Environnement_Definition_Meringen.txt',1);
SimObj = multilayerwindSimulator3D(Rocket_0, Environment, SimOutputs);
[T1, S1] = SimObj.RailSim();
[T2_1, S2_1, T2_1E, S2_1E, I2_1E] = SimObj.FlightSim([T1(end) SimObj.Rocket.Burn_Time(end)], S1(end, 2));
[T2_2, S2_2, T2_2E, S2_2E, I2_2E] = SimObj.FlightSim([T2_1(end) 40], S2_1(end, 1:3)', S2_1(end, 4:6)', S2_1(end, 7:10)', S2_1(end, 11:13)');
T2 = [T2_1; T2_2(2:end)];
S2 = [S2_1; S2_2(2:end, :)];
T_1_2 = [T1;T2];
S_1_2 = [S1;S2(:,3) S2(:,6)];
[T3, S3, T3E, S3E, I3E] = SimObj.DrogueParaSim(T2(end), S2(end,1:3)', S2(end, 4:6)');
[T4, S4, T4E, S4E, I4E] = SimObj.MainParaSim(T3(end), S3(end,1:3)', S3(end, 4:6)');

%plot rocket orientation
figure('Name','2D montecarlo'); hold on;
%plot trajectory of CM
plot3(S2(:,1), S2(:,2), S2(:,3), 'DisplayName', 'Ascent','LineWidth',1);
plot3(S3(:,1), S3(:,2), S3(:,3), 'DisplayName', 'Drogue Descent','LineWidth',1);
plot3(S4(:,1), S4(:,2), S4(:,3), 'DisplayName', 'Main Descent','LineWidth',1);
plot3(r_ellipse(:,1) + X0,r_ellipse(:,2) + Y0,0*r_ellipse(:,2),'DisplayName', '95% confidence Interval','LineWidth',1);
plot3(r_ellipse1(:,1) + X0,r_ellipse1(:,2) + Y0,0*r_ellipse1(:,2),'DisplayName', '99,99% confidence Interval','LineWidth',1);
plot3(data(:,1), data(:,2),0*data(:,2),'*k' , 'DisplayName', 'noised landing');
pbaspect([1 1 1]); pbaspect([1, 1, 1]); view(45, 45);
[XX, YY, M, Mcolor] = get_google_map(Environment.Start_Latitude, Environment.Start_Longitude, 'Height', ceil(diff(xlim)/3.4), 'Width', ceil(diff(ylim)/3.4));
xImage = [xlim',xlim'];
yImage = [ylim;ylim];
zImage = zeros(2);
colormap(Mcolor);
surf(xImage, yImage, zImage, 'CData', M,'FaceColor', 'texturemap', 'EdgeColor', 'none', 'DisplayName', 'Base Map');
title '3D trajectory representation'
xlabel 'S [m]'; ylabel 'E [m]'; zlabel 'Altitude [m]';
legend show;
