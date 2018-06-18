%% Rocket Simulator 3D

% Initialize
close all; clear all;
addpath(genpath('../Declarations'),...
        genpath('../Functions'),...
        genpath('../Snippets'),...
        genpath('../Simulator_1D'));

% Rocket Definition
Rocket = rocketReader('Rocket_Definition_Final.txt');
Environment = environnementReader('Environnement_Definition.txt');
SimOutputs = SimOutputReader('Simulation_outputs.txt');

SimObj = Simulator3D(Rocket, Environment, SimOutputs);

%% ------------------------------------------------------------------------
% 6DOF Rail Simulation
%--------------------------------------------------------------------------

[T1, S1] = SimObj.RailSim();

%% ------------------------------------------------------------------------
% 6DOF Flight Simulation
%--------------------------------------------------------------------------
[T2, S2, T2E, S2E, I2E] = SimObj.FlightSim(T1(end), S1(end,2));

%% ------------------------------------------------------------------------
% 3DOF Recovery Drogue
%--------------------------------------------------------------------------

[T3, S3, T3E, S3E, I3E] = SimObj.DrogueParaSim(T2(end), S2(end,1:3)', S2(end, 4:6)');

%% ------------------------------------------------------------------------
% 3DOF Recovery Main
%--------------------------------------------------------------------------

[T4, S4, T4E, S4E, I4E] = SimObj.MainParaSim(T3(end), S3(end,1:3)', S3(end, 4:6)');

%% ------------------------------------------------------------------------
% 3DOF Crash Simulation
%--------------------------------------------------------------------------

[T5, S5, T5E, S5E, I5E] = SimObj.CrashSim(T2(end), S2(end,1:3)', S2(end, 4:6)');

%% ------------------------------------------------------------------------
% Analyse results
%--------------------------------------------------------------------------

% PLOT 1 : 3D rocket trajectory

C = quat2rotmat(S2(:, 7:10));
angle = rot2anglemat(C);

% plot rocket orientation
figure; hold on;
direcv = zeros(length(C),3);
for i  = 1:length(C)
    direcv(i,:) = C(:,:,i)*[0;0;1];
end
quiver3(S2(:,1), S2(:,2), S2(:,3), direcv(:,1), direcv(:,2), direcv(:,3));

% plot trajectory of CM
plot3(S2(:,1), S2(:,2), S2(:,3), 'DisplayName', 'Ascent');
plot3(S3(:,1), S3(:,2), S3(:,3), 'DisplayName', 'Drogue Descent');
plot3(S4(:,1), S4(:,2), S4(:,3), 'DisplayName', 'Main Descent');
plot3(S5(:,1), S5(:,2), S5(:,3), 'DisplayName', 'Ballistic Descent')
daspect([1 1 1]); pbaspect([1, 1, 1]); view(45, 45);
[XX, YY, M, Mcolor] = get_google_map(Environment.Start_Latitude, Environment.Start_Longitude, 'Height', ceil(diff(xlim)/3.4), 'Width', ceil(diff(ylim)/3.4));
xImage = [xlim',xlim'];
yImage = [ylim;ylim];
zImage = zeros(2);
colormap(Mcolor);
surf(xImage, yImage, zImage, 'CData', M,'FaceColor', 'texturemap', 'EdgeColor', 'none', 'DisplayName', 'Base Map');
title '3D trajectory representation'
xlabel 'S [m]'; ylabel 'E [m]'; zlabel 'Altitude [m]';
legend show;

% PLOT 2 : time dependent altitude
figure; hold on;
plot(T2, S2(:,3));
plot(T3, S3(:,3));
plot(T4, S4(:,3));
plot(T5, S5(:,3));
title 'Altitude vs. time'
xlabel 't [s]'; ylabel 'Altitude [m]';

% PLOT 3 : Altitude vs. drift
figure; hold on;
plot(sqrt(S2(:,1).^2 + S2(:,2).^2), S2(:,3));
%quiver(sqrt(S2(:,1).^2 + S2(:,2).^2), S2(:,3), sqrt(direcv(:,1).^2 + direcv(:,2).^2), direcv(:,3));
plot(sqrt(S3(:,1).^2 + S3(:,2).^2), S3(:,3));
plot(sqrt(S4(:,1).^2 + S4(:,2).^2), S4(:,3));
plot(sqrt(S5(:,1).^2 + S5(:,2).^2), S5(:,3));
title 'Altitude vs. drift'
xlabel 'Drift [m]'; ylabel 'Altitude [m]';
daspect([1 1 1]);
