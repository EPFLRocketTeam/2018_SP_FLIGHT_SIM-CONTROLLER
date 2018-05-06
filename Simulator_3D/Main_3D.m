%% Rocket Simulator 3D

% Initialize
close all; clear all;
addpath(genpath('../Declarations'),...
        genpath('../Functions'),...
        genpath('../Snippets'),...
        genpath('../Simulator_1D'));

% Rocket Definition
Rocket = rocketReader('Rocket_Definition_Payerne.txt');
Environnement = environnementReader('Environnement_Definition.txt');

%% ------------------------------------------------------------------------
% 6DOF Rail Simulation
%--------------------------------------------------------------------------

% Initial Conditions
X0 = [0,0]'; % positioned at 0 height and 0 velocity

% time span 
tspan = [0, 5];

% options
Option = odeset('Events', @(t,x) RailEvent(t,x, Environnement));

% integration
[T,X] = ode45(@(t,x) Dynamics_Rail_1DOF(t,x,Rocket,Environnement),tspan,X0, Option);

%% ------------------------------------------------------------------------
% 6DOF Flight Simulation
%--------------------------------------------------------------------------

% Rail vector
C_rail = rotmat(Environnement.Rail_Angle, 2)*rotmat(-Environnement.Rail_Azimuth, 3);
RV = C_rail*[0;0;1];

% Initial Conditions
X0 = RV*Environnement.Rail_Length; % spatial position of cm
V0 = RV*X(end,2); % Initial velocity of cm
Q0 = rot2quat(C_rail); % Initial attitude
W0 = [0;0;0]; % Initial angular rotation in rocket principle coordinates
S0 = [X0; V0; Q0'; W0];

% time span
tspan = [T(end), 70];

% options
Option = odeset('Events', @FlightEventFunc);

% integration
[T,S, TE, YE, IE] = ode45(@(t,s) Dynamics_6DOF(t,s,Rocket,Environnement),tspan,S0, Option);

%% ------------------------------------------------------------------------
% Analyze results
%--------------------------------------------------------------------------

C = quat2rotmat(S(:, 7:10));
angle = rot2anglemat(C);

% plot trajectory of CM
figure; hold on;
% direcv = zeros(length(C),3);
% for i  = 1:length(C)
%     direcv(i,:) = C(:,:,i)*[0;0;1];
% end
% quiver3(S(:,1), S(:,2), S(:,3), direcv(:,1), direcv(:,2), direcv(:,3));
plot3(S(:,1), S(:,2), S(:,3));
daspect([1 1 1]); pbaspect([1, 1, 1]); view(45, 45);
title '3D trajectory representation'
xlabel 'N [m]'; ylabel 'W [m]'; zlabel 'Altitude [m]';

% plot Altitude vs. time
figure;
plot(T, S(:,3));
title 'Altitude vs. time'
xlabel 't [s]'; ylabel 'Altitude [m]';

% plot Altitude vs. drift
figure;
plot(sqrt(S(:,1).^2 + S(:,2).^2), S(:,3));
title 'Altitude vs. drift'
xlabel 'Drift [m]'; ylabel 'Altitude [m]';