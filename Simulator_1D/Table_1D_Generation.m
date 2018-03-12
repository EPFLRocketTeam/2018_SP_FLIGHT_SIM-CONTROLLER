% 1D Table Generation
%--------------------------------------------------------------------------
close all;clc


% -------------------------------------------------------------------------
% Environnement % Rocket Definitions
% -------------------------------------------------------------------------
Rocket = rocketReader('Rocket_Definition.txt');
Environnement = environnementReader('Environnement_Definition.txt');

% -------------------------------------------------------------------------
% Table Boundaries (Heigth, Vertical Speed)
% -------------------------------------------------------------------------
H = [1000 1500 2000 2500];
V = [100 150 200 250];

% -------------------------------------------------------------------------
% Simulation 1D
% -------------------------------------------------------------------------
Apogee = []; l = 0;
Option = odeset('Events', @myEvent);
for i = H
    Tmp = [];
    for j = V
        x_0 = [i,j];
        tspan = [7 20]; % Avoid motor thrust phase
        [T,X] = ode45(@(t,x) Rocket_Kinematic(t,x,Rocket,Environnement,-190.5),tspan,x_0,Option); %%%%%%%%%%% ADD CONDITIONAL STOP
        Tmp = [Tmp;max(X(:,1))];
        l = l+1;
        display(l);
    end
    Apogee = [Apogee Tmp];
end