%% Initialize
close all
clear all

% load directories
addpath(genpath('../Declarations'),...
        genpath('../Functions'),...
        genpath('../Snippets'),...
        genpath('../Simulator_1D'),...
        genpath('../Simulator_2D'));
    
% load definitions
Rocket_Payerne = rocketReader('BL_H3.txt');
Environment_Payerne = environnementReader('Environnement_Definition_USA.txt');
SimOutputs = SimOutputReader('Simulation_outputs.txt');

% Parameter
Wind_Azim = [0, 90, 180, 270];

%% Simulate

h1 = figure(1); ax1 = gca; hold(ax1, 'on');

for i = 1:length(Wind_Azim)
   
    Environment_Payerne.V_dir = [cosd(Wind_Azim(i)); sind(Wind_Azim(i));0];
    
    SimObj = Simulator3D(Rocket_Payerne, Environment_Payerne, SimOutputs);
    [T1, S1] = SimObj.RailSim();
    [T2, S2] = SimObj.FlightSim(T1(end), S1(end,2));
    [T3, S3] = SimObj.CrashSim(T2(end), S2(end,1:3)', S2(end, 4:6)');
    
    % plot trajectory
    plot3([S2(:,1);S3(:,1)], [S2(:,2);S3(:,2)], [S2(:,3);S3(:,3)], 'DisplayName', ['Azimuth = ' num2str(Wind_Azim(i))]);
    
end

%% Plot map
daspect([1 1 1]); pbaspect([1, 1, 1]); view(30, 50);
[XX, YY, M, Mcolor] = get_google_map(Environment_Payerne.Start_Latitude, Environment_Payerne.Start_Longitude, 'Height', ceil(diff(xlim)/3.4), 'Width', ceil(diff(ylim)/3.4));
xImage = [xlim',xlim'];
yImage = [ylim;ylim];
zImage = zeros(2);
colormap(Mcolor);
surf(xImage, yImage, zImage, 'CData', M,'FaceColor', 'texturemap', 'EdgeColor', 'none', 'DisplayName', 'Base Map');
title(['Trajectoire 3D, Vitesse du vent = ' num2str(Environment_Payerne.V_inf) ' m/s']);
xlabel 'S [m]'; ylabel 'E [m]'; zlabel 'Altitude [m]';
legend show;
set(gca, 'Fontsize', 14);

%% Plot real landing point

plot3(-400, -250, 10, 'dr', 'DisplayName', "Lieu d'aterrissage réel")