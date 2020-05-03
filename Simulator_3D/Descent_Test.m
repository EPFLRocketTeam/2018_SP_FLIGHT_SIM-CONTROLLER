%% Rocket Simulator 3D

% Initialize
close all; 
%clear all;
addpath(genpath('../Declarations'),...
        genpath('../Functions'),...
        genpath('../Snippets'),...
        genpath('../Simulator_1D'));

% Rocket Definition
Rocket = rocketReader('BL_H4.txt');
Environnement = environnementReader('Environnement_Definition.txt');

%% ------------------------------------------------------------------------
% 6DOF Flight Simulation
%--------------------------------------------------------------------------
% quaternion
delta = 9*pi/18;

% Initial Conditions
X0 = [0; 0; 3488]; % spatial position of cm
V0 = [1;0;-0.0001]; % Initial velocity of cm
Q0 = [0;0.7071;0;0.7071]; % Initial attitude
W0 = [0;0;0]; % Initial angular rotation in rocket principle coordinates
S0 = [X0; V0; Q0; W0];
% X0 = S2E(1,1:3)'; % spatial position of cm
% V0 = S2E(1,4:6)'; % Initial velocity of cm
% Q0 = [0;sin(delta/2);0;cos(delta/2)]; % Initial attitude
% %Q0 = S2E(1,7:10)';
% W0 = S2E(1,11:13)'; % Initial angular rotation in rocket principle coordinates
% S0 = [X0; V0; Q0; W0];

% time span
tspan = [10, 40];

% options
Option = odeset('Events', @FlightEventFunc);

% integration
[T, S, TE, SE, IE] = ode45(@(t,s) Dynamics_6DOF(t,s,Rocket,Environnement),tspan,S0, Option);
[T1, S1, TE1, SE1, IE1] = ode45(@(t,s) Dynamics_3DOF(t,s,Rocket,Environnement),tspan,S0(1:6), Option);
%% ------------------------------------------------------------------------
% 6DOF Result Analysis
%--------------------------------------------------------------------------

% plot Altitude vs. drift
C = quat2rotmat(S(:, 7:10));
%figure; 
hold on;
direcv = zeros(length(C),3);
for i  = 1:length(C)
    direcv(i,:) = C(:,:,i)*[0;0;1];
end
plot(S(:,1), S(:,3), 'DisplayName', ['\delta_0 = ' num2str(delta*180/pi) ', V_{\infty} = ' num2str(Environnement.V_inf) '6DOF']);
plot(S1(:,1), S1(:,3), 'DisplayName', ['\delta_0 = ' num2str(delta*180/pi) ', V_{\infty} = ' num2str(Environnement.V_inf) '3DOF']);
%quiver(S(:,1), S(:,3), direcv(:,1), direcv(:,3));
title 'Altitude vs. drift'
xlabel 'Drift [m]'; ylabel 'Altitude [m]';
%daspect([1 1 1]); pbaspect([1 1 1])
legend show