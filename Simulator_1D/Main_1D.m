%% Rocket Simulator 1D

%--------------------------------------------------------------------------
% Initialize
%--------------------------------------------------------------------------
close all; clear all;
addpath(genpath('../Declarations'),...
        genpath('../Functions'),...
        genpath('../Snippets'));
    
%--------------------------------------------------------------------------
% Rocket Simulations
%--------------------------------------------------------------------------

% Rocket Definition
Rocket = rocketReader('Rocket_Definition.txt');
Environnement = environnementReader('Environnement_Definition.txt');

% Initial Conditions
x_0 = [0;0]; % No speed, no height
tspan = [0 28];

% Simulation
Option = odeset('Events', @myEvent);
[T,X] = ode45(@(t,x) Rocket_Kinematic(t,x,Rocket,Environnement,-190.5, 1),tspan,x_0,Option);

%--------------------------------------------------------------------------
% Visualization
%--------------------------------------------------------------------------
pos=find(T>Rocket.Burn_Time);
figure(1);
plot(T,X(:,1));hold on;grid on;
plot(T(pos(1)),X(pos(1),1),'r*');
figure(2);
plot(X(:,1),X(:,2),'b');hold on;grid on;
plot(X(pos(1),1),X(pos(1),2),'r*');

%--------------------------------------------------------------------------
% What consider?
%--------------------------------------------------------------------------

h_0 = 1000;
h_f = max(X(:,1));
h = linspace(h_0,h_f,50);
v = interp1(X(:,1),X(:,2),h);

%--------------------------------------------------------------------------
% Generate Value For Embedded Kalman
%--------------------------------------------------------------------------
R_h = 2;
R_v = 2;
pos1 = 25;
X_1 = awgn(X(pos1:end,1),0.1,R_h);
X_2 = awgn(X(pos1:end,2),0.1,R_v);
T_1 = T(pos1:end);
xlswrite('Kalman_Data',[T_1';X_1';X_2']);
