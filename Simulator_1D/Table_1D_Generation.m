% 1D Table Generation
%--------------------------------------------------------------------------
close all;clc

% -------------------------------------------------------------------------
% Environnement % Rocket Definitions
% -------------------------------------------------------------------------
Rocket = rocketReader('Rocket_Definition.txt');
Environnement = environnementReader('Environnement_Definition.txt');

% -------------------------------------------------------------------------
% Angle Boundaries (Shuriken AB Table)
% -------------------------------------------------------------------------
theta = linspace(-190.5,1.165,10);

% -------------------------------------------------------------------------
% Simulation 1D
% -------------------------------------------------------------------------
% Thrust Phase Simulation
x_0 = [0;0];

tspan = [0 Rocket.Burn_Time];
Amplifier = 1;
[T,X] = ode45(@(t,x) Rocket_Kinematic(t,x,Rocket,Environnement,theta(1),Amplifier),tspan,x_0);
figure(1);
plot(T,X(:,1),'g','DisplayName','Thrust Phase');hold on
X_End_Burn = X(end,1);

tspan = [0 28];
Amplifier = 1.20;
[T,X] = ode45(@(t,x) Rocket_Kinematic(t,x,Rocket,Environnement,theta(1),Amplifier),tspan,x_0);
figure(1);
plot(T,X(:,1),'r','DisplayName','Thrust Phase');hold on

Amplifier = 0.8;
[T,X] = ode45(@(t,x) Rocket_Kinematic(t,x,Rocket,Environnement,theta(1),Amplifier),tspan,x_0);
figure(1);
plot(T,X(:,1),'b','DisplayName','Thrust Phase');hold on

Amplifier = 1;
[T_Nominal,X_Nominal] = ode45(@(t,x) Rocket_Kinematic(t,x,Rocket,Environnement,theta(1),Amplifier),tspan,x_0);
figure(1);
plot(T_Nominal,X_Nominal(:,1),'g','DisplayName','Thrust Phase');hold on

%% Backward Simulation
x_0 = [3048;0]; % Final condition wanted
tspan = [35 Rocket.Burn_Time]; % Avoid motor thrust phase
Data = []; % [Altitude, Speed, Angle of AB]
Option = odeset('Events', @myEvent);
for i = theta
    [T,X] = ode45(@(t,x) Rocket_Kinematic(t,x,Rocket,Environnement,i,Amplifier),tspan,x_0,Option); %%%%%%%%%%% ADD CONDITIONAL STOP
    display(i);
    Data = [Data;X(:,1) X(:,2) ones(length(X(:,1)),1)*i];
    pos = find(X(:,1)>X_End_Burn);
    figure(1);
    plot(T(pos)-T(pos(end))+6.5,X(pos,1),'k','DisplayName',['Angle = ' num2str(theta) 'Deg']);
end

%% Find Interesting altitude 
Alt = linspace(1000,3048,100);
for i = 1:length(tetha)
    
end
