%% Rocket Simulator 1D

%--------------------------------------------------------------------------
% Rocket Simulations
%--------------------------------------------------------------------------

% Rocket Definition
Rocket = rocketReader('Rocket_Definition.txt');
Environnement = environnementReader('Environnement_Definition.txt');

% Initial Conditions
x_0 = [2444,111.67]; % No speed, no height
tspan = [15 26];

% Simulation
Option = odeset('Events', @myEvent);
[T,X] = ode45(@(t,x) Rocket_Kinematic(t,x,Rocket,Environnement,-190.5),tspan,x_0,Option);

%--------------------------------------------------------------------------
% Visualization
%--------------------------------------------------------------------------
figure(1);
plot(T,X(:,1),'r');hold on;
figure(2);
plot(X(:,1),X(:,2),'r');hold on;grid on;

%--------------------------------------------------------------------------
% What consider?
%--------------------------------------------------------------------------

h_0 = 1000;
h_f = max(X(:,1));
h = linspace(h_0,h_f,50);
v = interp1(X(:,1),X(:,2),h);

