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
Rocket = rocketReader('Rocket_Definition_Eiger_I_Final.txt');
Environnement = environnementReader('Environnement_Definition_USA.txt');

% Initial Conditions
x_0 = [0;0]; % No speed, no height
tspan = [0 28];

% Simulation
Option = odeset('Events', @myEvent);
[T,X] = ode45(@(t,x) Rocket_Kinematic_R2(t,x,Rocket,Environnement,@drag_shuriken, -232),tspan,x_0,Option);

display(['Apogee AGL : ' num2str(X(end,1))]);
display(['Apogee AGL @t = ' num2str(T(end))]);
[maxi,index] = max(X(:,2));
display(['Max speed : ' num2str(maxi)]);
display(['Max speed @t = ' num2str(T(index))]);
[~,a,~,rho,nu] = stdAtmos(X(index,1),Environnement);
C_Dab = drag_shuriken(Rocket, 0, 0, maxi, nu);
F_Dab = 0.5*C_Dab*rho*pi*Rocket.dm^2/4*maxi^2;e) ➜ e) ➜  ~ matlab
Gtk-Message: 09:02:48.158: Failed to load module "canberra-gtk-module"







 ~ matlab
Gtk-Message: 09:02:48.158: Failed to load module "canberra-gtk-module"








display(['AB drag force at max speed = ' num2str(F_Dab)]);
display(['Max Mach number : ' num2str(maxi/a)]);
[maxi,index] = max(diff(X(:,2))./diff(T));
display(['Max acceleration : ' num2str(maxi)]);
display(['Max g : ' num2str(maxi/9.81)]);
display(['Max g @t = ' num2str(T(index))]);

%--------------------------------------------------------------------------
% Visualization
%--------------------------------------------------------------------------
pos=find(T>Rocket.Burn_Time);
figure(1);
plot(T,X(:,1));hold on;grid on;
%plot(T(pos(1)),X(pos(1),1),'r*');
%title('Simulateur 1D - Pr?diction altitude');
xlabel('Temps [s]');ylabel('Altitude [m]');

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
% R_h = 2;
% R_v = 2;
% pos1 = 25;
% X_1 = awgn(X(pos1:end,1),0.1,R_h);
% X_2 = awgn(X(pos1:end,2),0.1,R_v);
% T_1 = T(pos1:end);
% xlswrite('Kalman_Data',[T_1';X_1';X_2']);
