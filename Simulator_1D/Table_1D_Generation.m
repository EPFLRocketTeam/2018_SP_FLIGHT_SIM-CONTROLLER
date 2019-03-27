% 1D Table Generation
%--------------------------------------------------------------------------
close all;clc

% -------------------------------------------------------------------------
% Environnement % Rocket Definitions
% -------------------------------------------------------------------------
Rocket = rocketReader('Rocket/Rocket_Definition_Mat_III_2.txt');
Environnement = environnementReader('Environment/Environnement_Definition_Cernier.txt');

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
plot(T,X(:,1),'g','DisplayName','Thrust Phase');hold on,grid on;
X_End_Burn = X(end,1);

tspan = [0 28];
Amplifier = 1.20;
[T,X] = ode45(@(t,x) Rocket_Kinematic(t,x,Rocket,Environnement,theta(1),Amplifier),tspan,x_0);
figure(1);
plot(T,X(:,1),'r','DisplayName','Thrust Phase');hold on,grid on;

Amplifier = 0.8;
[T,X] = ode45(@(t,x) Rocket_Kinematic(t,x,Rocket,Environnement,theta(1),Amplifier),tspan,x_0);
figure(1);
plot(T,X(:,1),'b','DisplayName','Thrust Phase');hold on,grid on;

Amplifier = 1;
[T_Nominal,X_Nominal] = ode45(@(t,x) Rocket_Kinematic(t,x,Rocket,Environnement,theta(1),Amplifier),tspan,x_0);
figure(1);
plot(T_Nominal,X_Nominal(:,1),'g','DisplayName','Thrust Phase');hold on,grid on;

%% Backward Simulation
% Altitude of Interest
Alt = linspace(1000,3048,100);

% Simulation
x_0 = [3048;0]; % Final condition wanted
tspan = [35 Rocket.Burn_Time]; % Avoid motor thrust phase
Data = []; % [Altitude, Speed, Angle of AB]
Option = odeset('Events', @myEvent);
for i = theta
    % Simulation ----------------------------------------------------------
    [T,X] = ode45(@(t,x) Rocket_Kinematic(t,x,Rocket,Environnement,i,Amplifier),tspan,x_0,Option);
    %Data = [Data;X(:,1) X(:,2) ones(length(X(:,1)),1)*i];
    
    % Visualization -------------------------------------------------------
%     pos = find(X(:,1)>X_End_Burn);
%     figure(1);
%     plot(T(pos)-T(pos(end))+6.5,X(pos,1),'k','DisplayName',['Angle = ' num2str(theta) 'Deg']);
    
    % DATA  Acquisition ---------------------------------------------------
    pos = find(X(:,1)<3046);
    V = interp1(X(pos,1),X(pos,2),Alt,'linear','extrap');
    T = ones(1,length(Alt))*i;
    Data = [Data;Alt' V' T'];
end

Table = [];
L_Alt = length(Alt);
L_theta = length(theta);
pos = 1:L_Alt:L_Alt*L_theta;
for j = 1:L_Alt
    Table = [Table;Data(pos+j-1,1) Data(pos+j-1,2) Data(pos+j-1,3)];
end

%% Graph Check
pos1 = 1:L_theta:L_theta*L_Alt;
for k = 1:10
    figure(2);
    plot(Table(pos1+k-1,1),Table(pos1+k-1,2),'DisplayName',['Angle = ' num2str(theta(k))]);hold on;axis([1000 3100 0 250]);
    legend show;grid on;
end






