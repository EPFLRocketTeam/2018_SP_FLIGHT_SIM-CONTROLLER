%% Rocket Simulator 2D
% Rocket Definition
Rocket = rocketReader('Rocket_Definition.txt');
Environnement = environnementReader('Environnement_Definition.txt');

%--------------------------------------------------------------------------
% Rail Simulation
%--------------------------------------------------------------------------
% Initial Conditions
x_0 = [0;0]; % At rest position
tspan = [0 Rocket.Burn_Time];

% Simulation
Option = odeset('Events', @myEventRail);
[T1,X1] = ode45(@(t,x) Rail_Initial_State(t,x,Rocket,Environnement),tspan,x_0,Option);
 
%--------------------------------------------------------------------------
% Fly Simulation
%--------------------------------------------------------------------------
Rail_Angle = Environnement.Rail_Angle;
Rail_L = Environnement.Rail_Length;

% Initial Conditions
x_0 = [Rail_L*cos(Rail_Angle);X1(end,2)*cos(Rail_Angle);Rail_L*sin(Rail_Angle);X1(end,2)*sin(Rail_Angle);Rail_Angle;0]; % No speed, no height, no angle
tspan = [T1(end) 28];

% Simulation
Option = odeset('Events', @myEventApogee);
[T,X] = ode45(@(t,x) Rocket_Kinematic_2D(t,x,Rocket,Environnement,-190.5),tspan,x_0);

%--------------------------------------------------------------------------
% Visualization
%--------------------------------------------------------------------------
pos = find(T<Rocket.Burn_Time);
figure(1);
plot(X(:,3),X(:,1),'DisplayName','Trajectory');grid on;hold on;
plot(X(pos(end),3),X(pos(end),1),'r*');
title('2D Rocket Trajectory');
xlabel('Horizontal Position [m]');ylabel('Vertical Position [m]');

figure(2);
plot(T,X(:,1),'DisplayName','Altitude');grid on;
title('2D Rocket Altitude');
xlabel('Time [s]');ylabel('Vertical Position [m]');

figure(3);
plot(T,X(:,3),'DisplayName','Drift');grid on;
title('2D Rocket Drift');
xlabel('Time [s]');ylabel('Horizontal Position [m]');

figure(4);
plot(T,X(:,5)/pi*180,'DisplayName','Angle');grid on;
title('2D Rocket Angle');
xlabel('Time [s]');ylabel('Angle from vertical [deg]');