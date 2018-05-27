%% Rocket Simulator 2D

close all; clear all;

% Rocket Definition
Rocket = rocketReader('Rocket_Definition.txt');
Environnement = environnementReader('Environnement_Definition.txt');

update_time = 0.1;

%--------------------------------------------------------------------------
% Rail Simulation
%--------------------------------------------------------------------------
% Initial Conditions
x_0 = [0;0]; % At rest position
tspan = 0:update_time:Rocket.Burn_Time;

% Simulation
Option = odeset('Events', @myEventRail);
[T1,X1] = ode45(@(t,x) Rail_Initial_State(t,x,Rocket,Environnement),tspan,x_0,Option);
 
%--------------------------------------------------------------------------
% Fly Simulation
%--------------------------------------------------------------------------
Rail_Angle = Environnement.Rail_Angle;
Rail_L = Environnement.Rail_Length;

% Initial Conditions
x_0 = [Rail_L*sin(Rail_Angle);X1(end,2)*sin(Rail_Angle);Rail_L*cos(Rail_Angle);X1(end,2)*cos(Rail_Angle);Rail_Angle;0]; % No speed, no height, no angle
tspan = T1(end):update_time:28;

% Simulation
Option = odeset('Events', @myEventApogee);
[T2,X2] = ode45(@(t,x) Rocket_Kinematic_2D(t,x,Rocket,Environnement,@drag_shuriken,-190.5),tspan,x_0,Option);

%--------------------------------------------------------------------------
% Main Parachute at Apogee Simulation
%--------------------------------------------------------------------------

% Initial Conditions
x_0 = X2(end,1:4);
tspan = T2(end):update_time:300;

% Simulation
Option = odeset('Events', @myEventParachute);
[T3,X3] = ode45(@(t,x) Parachute_Kinematic_2D(t,x,Rocket,Environnement),tspan,x_0,Option);

% Visualization
<<<<<<< HEAD
pos = find(T<Rocket.Burn_Time);
figure(1);
plot(X(:,1),X(:,3),'DisplayName','Trajectory');grid on;hold on;
plot(X(pos(end),1),X(pos(end),3),'r*');
title('2D Rocket Trajectory');
xlabel('Horizontal Position [m]');ylabel('Vertical Position [m]');

% figure(2);
% plot(T,X(:,3),'DisplayName','Altitude');grid on;
% title('2D Rocket Altitude');
% xlabel('Time [s]');ylabel('Vertical Position [m]');
% 
% figure(3);
% plot(T,X(:,1),'DisplayName','Drift');grid on;
% title('2D Rocket Drift');
% xlabel('Time [s]');ylabel('Horizontal Position [m]');
=======
%--------------------------------------------------------------------------
pos = find(T2<Rocket.Burn_Time);
figure(1); hold on;
plot(X2(:,1),X2(:,3),'DisplayName','Ascent Trajectory');
plot(X3(:,1),X3(:,3),'DisplayName','Main Para Trajectory');
plot(X2(pos(end),1),X2(pos(end),3),'r*', 'DisplayName', 'Burnout');
grid on; legend show;
title('2D Rocket Trajectory');
xlabel('Horizontal Position [m]');ylabel('Vertical Position [m]');

figure(2); hold on;
plot(T2,X2(:,3),'DisplayName','Ascent');
plot(T3,X3(:,3), 'DisplayName', 'Main Para Descent');
plot(T2(pos(end)),X2(pos(end),3),'r*', 'DisplayName', 'Burnout');
grid on; legend show;
title('2D Rocket Altitude');
xlabel('Time [s]');ylabel('Vertical Position [m]');

figure(3);
plot(T2,X2(:,1),'DisplayName','Drift');grid on;
title('2D Rocket Drift');
xlabel('Time [s]');ylabel('Horizontal Position [m]');
>>>>>>> 2D_revision

figure(4);
hold on;
plot(T2,X2(:,5)/pi*180,'DisplayName','Angle');grid on;
title('2D Rocket Angle');
xlabel('Time [s]');ylabel('Angle from vertical [deg]');

%% New Section for 2 steps solution
%--------------------------------------------------------------------------
% Free Fall Simulation
%--------------------------------------------------------------------------
% Initial Conditions
apogeee = X(end,3);
x_0 = [X(end,1);X(end,2);-X(end,3);0;pi/2;-X(end,6)]; % Free Fall starting at apogee
tspan = [T(end) T(end)+50]; % Large scale, motor is avoided

Option = odeset('Events', @myEventGround);
[T,X] = ode45(@(t,x) Free_Fall_Kinematic(t,x,Rocket,Environnement,-190.5),tspan,x_0,Option);

% Visualization
pos = find(T<Rocket.Burn_Time);
figure(1);
plot(X(:,1),-X(:,3),'DisplayName','Free Fall');

% figure(2);
% plot(T,X(:,3),'DisplayName','Altitude');grid on;
% title('2D Rocket Altitude');
% xlabel('Time [s]');ylabel('Vertical Position [m]');

% figure(3);
% plot(T,X(:,1),'DisplayName','Drift');grid on;
% title('2D Rocket Drift');
% xlabel('Time [s]');ylabel('Horizontal Position [m]');

figure(4);
hold on;
plot(T,(pi-X(:,5))/pi*180,'DisplayName','Angle');grid on;

