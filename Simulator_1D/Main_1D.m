%% Rocket Simuator 1D

%--------------------------------------------------------------------------
% Rocket Simulations
%--------------------------------------------------------------------------

% Rocket Definition
Rocket = rocketReader('Rocket_Definition.txt');

% Initial Conditions
x_0 = [0;0] % No speed, no height
tspan = [0,30];

% Simulation
[T,X] = ode45(@(t,x) Rocket_Kinematic(t,x,Rocket),tspan,x_0);