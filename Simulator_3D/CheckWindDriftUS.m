%% Initialize

close all; clear all;
addpath(genpath('../Declarations'),...
        genpath('../Functions'),...
        genpath('../Snippets'),...
        genpath('../Simulator_1D'));

% Rocket Definition
Rocket = rocketReader('Rocket_Definition_Final.txt');
Environment = environnementReader('Environnement_Definition.txt');
SimOutputs = SimOutputReader('Simulation_outputs.txt');

%% Simulate and plot trajectories

h1 = figure(1); ax1 = gca; hold(ax1, 'on');
h2 = figure(2); ax2 = gca; hold(ax2, 'on');

X_Para = [];
X_NoPara = [];
V = -6:2:6;

for v = V

    Environment.V_inf = v;
    
    SimObj = Simulator3D(Rocket, Environment, SimOutputs);
    
    %% ------------------------------------------------------------------------
    % 6DOF Rail Simulation
    %--------------------------------------------------------------------------

    [T1, S1] = SimObj.RailSim();

    %% ------------------------------------------------------------------------
    % 6DOF Flight Simulation
    %--------------------------------------------------------------------------

    [T2, S2] = SimObj.FlightSim(T1(end), S1(end,2));

    %% ------------------------------------------------------------------------
    % 3DOF Recovery Drogue
    %--------------------------------------------------------------------------

    [T3, S3] = SimObj.DrogueParaSim(T2(end), S2(end,1:3)', S2(end, 4:6)');

    %% ------------------------------------------------------------------------
    % 3DOF Recovery Main
    %--------------------------------------------------------------------------

    [T4, S4] = SimObj.MainParaSim(T3(end), S3(end,1:3)', S3(end, 4:6)');
    
    %% ------------------------------------------------------------------------
    % 3DOF Crash Simulation
    %--------------------------------------------------------------------------

    [T5, S5, T5E, S5E, I5E] = SimObj.CrashSim(T2(end), S2(end,1:3)', S2(end, 4:6)');

    plot3(ax1, [S2(:,1);S3(:,1);S4(:,1)], [S2(:,2);S3(:,2);S4(:,2)], [S2(:,3);S3(:,3);S4(:,3)], 'DisplayName', ['Trajectoire, v = ' num2str(V)]);
    plot3(ax2, [S2(:,1);S5(:,1)], [S2(:,2);S5(:,2)], [S2(:,3);S5(:,3)], 'DisplayName', ['Trajectoire, v = ' num2str(V)]);
    
    X_Para = [X_Para, S4(end,1)];
    X_NoPara = [X_NoPara, S5(end,1)];
end

%% Plot map
axes(ax1);
daspect([1 1 1]); pbaspect([0.5, 0.5, 1]); view(30, 50);
% [XX, YY, M, Mcolor] = get_google_map(Environment.Start_Latitude, Environment.Start_Longitude, 'Height', ceil(diff(xlim)/3.4), 'Width', ceil(diff(ylim)/3.4));
xImage = [xlim',xlim'];
yImage = [ylim;ylim];
zImage = zeros(2);
% colormap(Mcolor);
% surf(xImage, yImage, zImage, 'CData', M,'FaceColor', 'texturemap', 'EdgeColor', 'none', 'DisplayName', 'Base Map');
% title('Sensibilité au vent, parachute déployé');
% xlabel('S [m]'); ylabel 'E [m]'; zlabel 'Altitude [m]';
% legend show;
% set(ax1, 'Fontsize', 14)

axes(ax2);
daspect([1 1 1]); pbaspect([0.5, 0.5, 1]); view(30, 50);
% [XX, YY, M, Mcolor] = get_google_map(Environment.Start_Latitude, Environment.Start_Longitude, 'Height', ceil(diff(xlim)/3.4), 'Width', ceil(diff(ylim)/3.4));
xImage = [xlim',xlim'];
yImage = [ylim;ylim];
zImage = zeros(2);
% colormap(Mcolor);
% surf(xImage, yImage, zImage, 'CData', M,'FaceColor', 'texturemap', 'EdgeColor', 'none', 'DisplayName', 'Base Map');
% title('Sensibilité au vent, parachute non-déployé');
% xlabel('S [m]'); ylabel 'E [m]'; zlabel 'Altitude [m]';
% legend show;
% set(ax2, 'Fontsize', 14);

figure(3); hold on;
plot(V, X_Para, 'DisplayName', 'Drift avec parachute');
plot(V, X_NoPara, 'DisplayName', 'Drift sans parachute');
title('Drift en fonction du vent')
xlabel('V [m/s]'); ylabel('Drift [m]');
l = legend('show'); set(l, 'Location', 'NorthWest');
set(gca, 'Fontsize', 14);
grid on;