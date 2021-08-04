% Initialize
%close all; 
%clear all;
addpath(genpath('../Declarations'),...
        genpath('../Functions'),...
        genpath('../Snippets'),...
        genpath('../Simulator_1D'));

% Rocket Definition
n_sim = 10;
Rocket_0 =  rocketReader('stf06.txt');
SimOutputs = SimOutputReader('Simulation/Simulation_outputs.txt');
name_of_environnment = 'Environnement_Definition_Wasserfallen.txt';

%wind parameters
angle=180;%center of the interval
var_angle=180;%size of the interval
n_sim_angle=35;%number of wind angles
azi=linspace(angle-var_angle,angle+var_angle,n_sim_angle);%full range interval

figure('Name','montecarlo'); hold on;
for i=1:n_sim_angle
wind_ch([7 8 8 9 9 10 10],[10 100 250 500 750 1000 1500],azi(i),0.3,name_of_environnment);%rewrite envrionment file
if n_sim ~= 0
[azed,r_ellipse,r_ellipse1, X0, Y0, data] = landing_tool(n_sim,-1,-1, Rocket_0, SimOutputs, name_of_environnment );
end

Environment = environnementReader(name_of_environnment,1);

%plot rocket 
zoom = 14;
metersPerPx = 156543.03392 * cos(Environment.Start_Latitude*pi/180)/ 2^zoom;
lim = metersPerPx*640/2; % because [-lim + lim ] = 2 lim
xlim = [-lim lim];
ylim = [-lim lim];
xImage = [xlim',xlim'];
yImage = [ylim;ylim];
zImage = zeros(2);
if (azi(i)==azi(1))
colormap('jet');
surf(Environment.map_x, Environment.map_y, Environment.map_z-Environment.Start_Latitude, 'EdgeColor', 'none', 'DisplayName', 'Base Map');
end
if n_sim ~= 0
plot3(r_ellipse1(:,1) + X0,r_ellipse1(:,2) + Y0,find_altitude(r_ellipse1(:,1) + X0,r_ellipse1(:,2) + Y0,Environment),'DisplayName', [num2str(azi(i)),'°'],'LineWidth',2);
end
daspect([1 1 1]); pbaspect([1, 1, 2]); view(45, 45);
title '99.99% confidence interval landing zone' %'3D trajectory representation'
xlabel 'S [m]'; ylabel 'E [m]'; zlabel 'Altitude [m]';
legend show;
end