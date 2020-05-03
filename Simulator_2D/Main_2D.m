%% Rocket Simulator 2D

% Initialize
close all; clear all;
addpath(genpath('../Declarations'),...
        genpath('../Functions'),...
        genpath('../Snippets'),...
        genpath('../Simulator_1D'));
    
% Rocket Definition
Rocket = rocketReader('Rocket/Rocket_Definition_Mat_III.txt');
Environnement = environnementReader('Environment/Environnement_Definition_USA.txt');

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
x_0 = [Rail_L*sin(Rail_Angle);X1(end,2)*sin(Rail_Angle);Rail_L*cos(Rail_Angle);X1(end,2)*cos(Rail_Angle);Rail_Angle;0]; % No speed, no height, no angle
tspan = [T1(end) 28];

% Simulation
Option = odeset('Events', @myEventApogee);
[T,X] = ode45(@(t,x) Rocket_Kinematic_2D(t,x,Rocket,Environnement,-190.5),tspan,x_0,Option);

% Visualization
pos = find(T<Rocket.Burn_Time);
figure(1);
plot(X(:,1),X(:,3),'DisplayName',['V_{\infty} = ' num2str(Environnement.V_inf) 'm/s']);grid on;hold on;
plot(X(pos(end),1),X(pos(end),3),'r*');
title("Simulateur 2D - Effet de l'angle du rail, V_{\infty} = 4 m/s");legend show;
xlabel('Position Horizontale [m]');ylabel('Position Verticale [m]');

% figure(2);
% plot(T,X(:,3),'DisplayName',['V_{\infty} = ' num2str(Environnement.V_inf) 'm/s']);grid on;hold on
% %plot(T(pos(end)),X(pos(end),3),'r*');
% title('Simulateur 2D - ');legend show;
% xlabel('Temps [s]');ylabel('Altitude [m]');
% 
% figure(3);
% plot(T,X(:,1),'DisplayName','Drift');grid on;
% title('2D Rocket Drift');
% xlabel('Time [s]');ylabel('Horizontal Position [m]');

% figure(4);
% hold on;
% plot(T,X(:,5)/pi*180,'DisplayName',['V_{\infty} = ' num2str(Environnement.V_inf) 'm/s']);grid on;
% title('Simulateur 2D - ');
% xlabel('Temps [s]');ylabel('Angle depuis la verticale [deg]');

%% New Section for 2 steps solution
% %--------------------------------------------------------------------------
% % Free Fall Simulation
% %--------------------------------------------------------------------------
% % Initial Conditions
% apogeee = X(end,3);
% x_0 = [X(end,1);X(end,2);-X(end,3);0;pi/2;-X(end,6)]; % Free Fall starting at apogee
% tspan = [T(end) T(end)+50]; % Large scale, motor is avoided
% 
% Option = odeset('Events', @myEventGround);
% [T,X] = ode45(@(t,x) Free_Fall_Kinematic(t,x,Rocket,Environnement,-190.5),tspan,x_0,Option);
% 
% % Visualization
% pos = find(T<Rocket.Burn_Time);
% figure(1);
% plot(X(:,1),-X(:,3),'DisplayName','Free Fall');
% 
% % figure(2);
% % plot(T,X(:,3),'DisplayName','Altitude');grid on;
% % title('2D Rocket Altitude');
% % xlabel('Time [s]');ylabel('Vertical Position [m]');
% 
% % figure(3);
% % plot(T,X(:,1),'DisplayName','Drift');grid on;
% % title('2D Rocket Drift');
% % xlabel('Time [s]');ylabel('Horizontal Position [m]');
% 
% figure(4);
% hold on;
% plot(T,(pi-X(:,5))/pi*180,'DisplayName','Angle');grid on;
% 
