%% Rocket Simulator 3D

% Initialize
close all; clear all;
addpath(genpath('../Declarations'),...
        genpath('../Functions'),...
        genpath('../Snippets'),...
        genpath('../Simulator_1D'));

% Rocket Definition
Rocket = rocketReader('Rocket_Definition.txt');
Environnement = environnementReader('Environnement_Definition.txt');

%% ------------------------------------------------------------------------
% 6DOF Rail Simulation
%--------------------------------------------------------------------------

% Initial Conditions
X0 = [0,0]'; % positioned at 0 height and 0 velocity

% time span 
tspan = [0, 5];

% options
Option = odeset('Events', @(t,x) RailEvent(t,x,Environnement));

% integration
[T1,S1] = ode45(@(t,x) Dynamics_Rail_1DOF(t,x,Rocket,Environnement),tspan,X0, Option);

%% ------------------------------------------------------------------------
% 6DOF Flight Simulation
%--------------------------------------------------------------------------

% Rail vector
C_rail = rotmat(Environnement.Rail_Angle, 2)*rotmat(-Environnement.Rail_Azimuth, 3);
RV = C_rail*[0;0;1];

% Initial Conditions
X0 = RV*Environnement.Rail_Length; % spatial position of cm
V0 = RV*S1(end,2); % Initial velocity of cm
Q0 = rot2quat(C_rail); % Initial attitude
W0 = [0;0;0]; % Initial angular rotation in rocket principle coordinates
S0 = [X0; V0; Q0'; W0];

% time span
tspan = [T1(end), 100];

% options
Option = odeset('Events', @ApogeeEvent, 'RelTol', 1e-6, 'AbsTol', 1e-6);

% integration
[T2,S2, T2E, S2E, I2E] = ode45(@(t,s) Dynamics_6DOF(t,s,Rocket,Environnement),tspan,S0, Option);

display(['Apogee : ' num2str(max(S2(:,3)))]);

%% ------------------------------------------------------------------------
% 3DOF Recovery Drogue
%--------------------------------------------------------------------------

% initial conditions
X0 = S2E(1,1:3);
V0 = S2E(1,4:6);
S0 = [X0, V0];

% empty mass
M = Rocket.rocket_m - Rocket.pl_mass;

% time span
tspan = [T2E(1), 500];

% options 
Option = odeset('Events', @(T,X) MainEvent(T,X,Rocket));

% integration
[T3,S3, T3E, S3E, I3E] = ode45(@(t,s) Dynamics_Parachute_3DOF(t,s,Rocket,Environnement, M, 0),tspan,S0, Option);

%% ------------------------------------------------------------------------
% 3DOF Recovery Main
%--------------------------------------------------------------------------

% initial conditions
X0 = S3E(1:3);
V0 = S3E(4:6);
S0 = [X0, V0];

% empty mass
M = Rocket.rocket_m - Rocket.pl_mass;

% time span
tspan = [T3E(1), 500];

% options 
Option = odeset('Events', @CrashEvent);

% integration
[T4, S4, T4E, S4E, I4E] = ode45(@(t,s) Dynamics_Parachute_3DOF(t,s,Rocket,Environnement, M, 1),tspan,S0, Option);

%% ------------------------------------------------------------------------
% 3DOF Apogee Simulation
%--------------------------------------------------------------------------

% Initial Conditions
X0 = S2E(1,1:3)'; % spatial position of cm
V0 = S2E(1,4:6)'; % Initial velocity of cm
S0 = [X0; V0];

% time span
tspan = [T2(end), 100];

% options
Option = odeset('Events', @CrashEvent);

% integration
[T5,S5] = ode45(@(t,s) Dynamics_3DOF(t,s,Rocket,Environnement),tspan,S0, Option);

%% ------------------------------------------------------------------------
% 6DOF Crash Simulation
%--------------------------------------------------------------------------

% % Initial Conditions
% X0 = S6(end,1:3)'; % spatial position of cm
% V0 = S6(end,4:6)'; % Initial velocity of cm
% % X0 = S2E(1,1:3)'; % spatial position of cm
% % V0 = S2E(1,4:6)'; % Initial velocity of cm
% Vnorm = normalizeVect(V0);
% Vcross = cross([0;0;1], Vnorm);
% if(norm(Vcross)==0)
%     delta = pi;
%    e = [1;0;0];
% else
%     delta = atan2(norm(Vcross), dot([0;0;1], Vnorm));
%     e = normalizeVect(Vcross);
% end
% Q0 = [e*sin(delta/2);cos(delta/2)]; % Initial attitude
% W0 = [0;0;0]; % Initial angular rotation in rocket principle coordinates
% S0 = [X0; V0; Q0; W0];
% 
% % time span
% tspan = [T2(end), 100];
% 
% % options
% Option = odeset('Events', @CrashEvent);
% 
% % integration
% [T5,S5, T5E, S5E, I5E] = ode45(@(t,s) Dynamics_6DOF(t,s,Rocket,Environnement),tspan,S0, Option);

%% ------------------------------------------------------------------------
% Analyze results
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
[XX, YY, M, Mcolor] = get_google_map(Environnement.Start_Latitude, Environnement.Start_Longitude, 'Height', ceil(diff(xlim)/3.4), 'Width', ceil(diff(ylim)/3.4));
xImage = [xlim',xlim'];
yImage = [ylim;ylim];
zImage = zeros(2);
colormap(Mcolor);
surf(xImage, yImage, zImage, 'CData', M,'FaceColor', 'texturemap', 'EdgeColor', 'none', 'DisplayName', 'Base Map');
title '3D trajectory representation'
xlabel 'N [m]'; ylabel 'W [m]'; zlabel 'Altitude [m]';
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
