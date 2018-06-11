%%  Basic Stability Assessment
%   Semester Project 
%   Emilien Mingard
%   
%   Equation Assumption:
%   - Linearized at Rail Velocity => lower Bound
%   - Linear Differential Equation Homogeneous
clear all; close all; clc;
Rocket = rocketReader('Rocket_Definition_Final.txt');
Environnement = environnementReader('Environnement_Definition.txt');

%--------------------------------------------------------------------------
% 1 Equation: Id2a/dt2+C2da/dt+C1a = f1(t) without Roll (Decoupled Equ.)
%--------------------------------------------------------------------------
Amplitude1 = [];
t1 = linspace(0,40,1000);
Velocity = 250;   % Rocket speed at rail tip
V_infi = [1:2:10];      % Wind speed

for V_inf = V_infi
    
a_0 = 0;    % Rail condition
da_0 = 0;   % Rail condition
[Calpha, CP] = barrowmanLift(Rocket,0,Velocity/346,0); % No roll
[CNa, Xp] = normalLift(Rocket,0,1.1,Velocity/346,0,0);
C1 = CorrectionMoment(0,Rocket,CNa,Xp,Velocity,Environnement,0);
C2 = DampingMoment(0,Rocket,Calpha,CP,Velocity,Environnement,0);
[M,dMdt,Cm,dCmdt,I_L,dI_Ldt,I_R,dI_Rdt] = Mass_Properties(Rocket.Burn_Time,Rocket,'Linear');

% 1.1 Wind disturbance:
beta = atan(V_inf/Velocity);
Ms = C1*beta;

% 1.2 Solutions:
damp = C1/I_L - C2^2/4/I_L^2; % Damping ratio
if damp > 0
    w = sqrt(damp);
    D = C2/I_L/2;
    phi = atan(w/D);
    A = - Ms/C1/sin(phi);
    a = @(t) A*exp(-D*t).*sin(w*t+phi)+Ms/C1;
elseif damp == 0
    w = sqrt(damp);
    D = C2/I_L/2;
    A1 = -Ms/C1;
    A2 = -D*Ms/C1;
    a = @(t) (A1+A2*t)*exp(-D*t)+Ms/C1;
elseif damp <= 0
    tau1 = 1/(C2/2/I_L-sqrt(-damp));
    tau2 = 1/(C2/2/I_L+sqrt(-damp));
    A1 = -Ms*tau1/(tau1-tau2)/C1;
    A2 = Ms*tau2/(tau1-tau2)/C1;
    a = @(t) A1*exp(-t/tau1)+A2*exp(-t/tau2)+Ms/C1;
end

% 1.3 Max of Amplitude
sol = a(t1);
Amplitude1 = [Amplitude1 max([max(sol-Ms/C1) -min(sol-Ms/C1)])];
figure (999);
plot(t1,sol*180/pi,'DisplayName',['V_{inf} = ' num2str(V_inf)]);grid on;hold on;
end
legend show;
% 1.4 Results:
figure(2);
plot(V_infi,Amplitude1/pi*180,'r');hold on;grid on;
xlabel('Wind Velocity [m/s]');ylabel('Amplitude of oscillation [deg]');
title('Amplitude vs Velocity at rail exit')

%--------------------------------------------------------------------------
% 2 Equation: Id2a/dt2+C2da/dt+C1a = delta(0) without Roll (Decoupled Equ.)
%--------------------------------------------------------------------------
Amplitude2 = [];
t2 = linspace(0,30,1000);
V_wind = 10; % Wind rafal speed [m/s]
Velocity = 250;      % Rocket speed at rail tip
T_wind = [0.5 1 1.5]; % Wind rafal time [s]

for t_wind = T_wind
 
[Calpha, CP] = barrowmanLift(Rocket,0,Velocity/346,0); % No roll
[CNa, Xp] = normalLift(Rocket,0,1.1,Velocity/346,0,0);
C1 = CorrectionMoment(0,Rocket,CNa,Xp,Velocity,Environnement,0);
C2 = DampingMoment(0,Rocket,Calpha,CP,Velocity,Environnement,0);

H = C1*atan(V_wind/Velocity)*t_wind
% 1.2 Solutions:
damp = C1/Rocket.rocket_I - C2^2/4/Rocket.rocket_I^2; % Damping ratio
if damp > 0
    D = C2/Rocket.rocket_I/2;
    w = sqrt(damp);
    a = @(t) H/Rocket.rocket_I/w*exp(-D*t).*sin(w*t);
elseif damp == 0
    D = C2/Rocket.rocket_I/2;
    a = @(t) H/Rocket.rocket_I*t.*exp(-D*t);
elseif damp <= 0
    tau1 = 1/(C2/2/Rocket.rocket_I-sqrt(-damp));
    tau2 = 1/(C2/2/Rocket.rocket_I+sqrt(-damp));
    a = @(t) H*tau1*tau2/(tau1-tau2)/I_l*(exp(-t/tau1)-exp(-t/tau2));
end

% 1.3 Max of Amplitude
sol = a(t2);
Amplitude2 = [Amplitude2 max([max(sol) -min(sol)])];
figure(3);
plot(t2,sol*180/pi,'DisplayName',['T_r = ' num2str(t_wind) 's']);grid on;hold on;
legend show;
end

% 1.4 Results:
figure(4);
plot(T_wind*V_wind,Amplitude2/pi*180,'r');hold on;grid on;
xlabel('Impulse Strength [m]');ylabel('Amplitude of oscillation [deg]');
title('Amplitude vs Wind impulsion at rail exit')