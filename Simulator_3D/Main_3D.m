%% Rocket Simulator 3D
% Rocket Definition
Rocket = rocketReader('Rocket_Definition.txt');
Environnement = environnementReader('Environnement_Definition.txt');

%--------------------------------------------------------------------------
% 6DOF Simulation
%--------------------------------------------------------------------------
% Initial Conditions
X0 = [0,0,0]; % spatial position of cm
V0 = [0,0,0]; % Initial velocity of cm
Q0 = [0,0,1,0]; % quaternion attitude
W0 = [0,0,0]; % Initial angular rotation in rocket principle coordinates
initial_condition = [X0, V0, Q0, W0];

% time span
tspan = [0, 30];

% integration
[T,S] = ode45(@(t,s) Dynamics_6DOF(t,s,Rocket,Environnement),tspan,initial_condition);

