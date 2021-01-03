%% Rocket Simulator 3D

% Initialize
close all; clear all;
addpath(genpath('../Declarations'),...
        genpath('../Functions'),...
        genpath('../Snippets'),...
        genpath('../Simulator_1D'));

% Rocket Definition
Rocket = rocketReader('WASSERFALLEN_FRANKENSTEIN.txt');
Environment = environnementReader('Environment/Environnement_Definition_Wasserfallen.txt');
SimOutputs = SimOutputReader('Simulation/Simulation_outputs.txt');

SimObj = multilayerwindSimulator3D(Rocket, Environment, SimOutputs);

%% ------------------------------------------------------------------------
% 6DOF Rail Simulation
%--------------------------------------------------------------------------

[T1, S1] = SimObj.RailSim();

display(['Launch rail departure velocity : ' num2str(S1(end,2))]);
display(['Launch rail departure time : ' num2str(T1(end))]);

%% ------------------------------------------------------------------------
% 6DOF Flight Simulation
%--------------------------------------------------------------------------

[T2_1, S2_1, T2_1E, S2_1E, I2_1E] = SimObj.FlightSim([T1(end) SimObj.Rocket.Burn_Time(end)], S1(end, 2));

%SimObj.Rocket.cone_mode = 'off';

[T2_2, S2_2, T2_2E, S2_2E, I2_2E] = SimObj.FlightSim([T2_1(end) 40], S2_1(end, 1:3)', S2_1(end, 4:6)', S2_1(end, 7:10)', S2_1(end, 11:13)');

T2 = [T2_1; T2_2(2:end)];
S2 = [S2_1; S2_2(2:end, :)];

T_1_2 = [T1;T2];
S_1_2 = [S1;S2(:,3) S2(:,6)];

display(['Apogee AGL : ' num2str(S2(end,3))]);
display(['Apogee AGL @t = ' num2str(T2(end))]);
[maxi,index] = max(S2(:,6));
display(['Max speed : ' num2str(maxi)]);
display(['Max speed @t = ' num2str(T2(index))]);
[~,a,~,rho,nu] = stdAtmos(S2(index,3),Environment);
Fd = 0.5*SimObj.SimAuxResults.Cd(index)*rho*pi*Rocket.dm^2/4*maxi^2;
display(['Max drag force = ' num2str(Fd)]);
display(['Max drag force along rocket axis = ' num2str(Fd*cos(SimObj.SimAuxResults.Delta(index)))]);
C_Dab = drag_shuriken(Rocket, 0, SimObj.SimAuxResults.Delta(index), maxi, nu);
F_Dab = 0.5*C_Dab*rho*pi*Rocket.dm^2/4*maxi^2;
display(['AB drag force at max speed = ' num2str(F_Dab)]);
display(['Max Mach number : ' num2str(maxi/a)]);
[maxi,index] = max(diff(S_1_2(:,2))./diff(T_1_2));
display(['Max acceleration : ' num2str(maxi)]);
display(['Max g : ' num2str(maxi/9.81)]);
display(['Max g @t = ' num2str(T_1_2(index))]);

%% ------------------------------------------------------------------------
% 3DOF Recovery Drogue
%--------------------------------------------------------------------------

[T3, S3, T3E, S3E, I3E] = SimObj.DrogueParaSim(T2(end), S2(end,1:3)', S2(end, 4:6)');

%% ------------------------------------------------------------------------
% 3DOF Recovery Main
%--------------------------------------------------------------------------

[T4, S4, T4E, S4E, I4E] = SimObj.MainParaSim(T3(end), S3(end,1:3)', S3(end, 4:6)');

display(['Touchdown @t = ' num2str(T4(end)) ' = ' num2str(floor(T4(end)/60)) ' min ' num2str(mod(T4(end),60)) ' s']);

%% ------------------------------------------------------------------------
% 3DOF Crash Simulation
%--------------------------------------------------------------------------

[T5, S5, T5E, S5E, I5E] = SimObj.CrashSim(T2(end), S2(end,1:3)', S2(end, 4:6)');




%--------------------------------------------------------------------------

PlotShowAns = input('Show plots ? [Y/N]\n','s');
if ~strcmp(PlotShowAns,{'Y','y','Yes','yes'})
    return
end

%% ------------------------------------------------------------------------
% Plots
%--------------------------------------------------------------------------

% PLOT 1 : 3D rocket trajectory

C = quat2rotmat(S2(:, 7:10));
angle = rot2anglemat(C);

% plot rocket orientation
figure('Name','3D Trajectory Representation'); hold on;
direcv = zeros(length(C),3);
for i  = 1:length(C)
    direcv(i,:) = C(:,:,i)*[0;0;1];
end
%quiver3(S2(:,1), S2(:,2), S2(:,3), direcv(:,1), direcv(:,2), direcv(:,3));

% plot trajectory of CM
plot3(S2(:,1), S2(:,2), S2(:,3), 'DisplayName', 'Ascent','LineWidth',2);
plot3(S3(:,1), S3(:,2), S3(:,3), 'DisplayName', 'Drogue Descent','LineWidth',2);
plot3(S4(:,1), S4(:,2), S4(:,3), 'DisplayName', 'Main Descent','LineWidth',2);
plot3(S5(:,1), S5(:,2), S5(:,3), 'DisplayName', 'Ballistic Descent','LineWidth',2)
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

