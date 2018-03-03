%%  Basic Stability Assessment
%   Semester Project 
%   Emilien Mingard
%   
%   Equation Assumption:
%   - Linearized at Rail Velocity => lower Bound
%   - Linear Differential Equation Homogeneous
clear all; close all; clc;
Rocket = rocketReader('Rocket_Definition.txt');

%--------------------------------------------------------------------------
% 1 Equation: Id2a/dt2+C2da/dt+C1a = f1(t) without Roll (Decoupled Equ.)
%--------------------------------------------------------------------------
Amplitude = [];
t = linspace(0,30,1000);
V = [5:1:100];
V_inf = 5;

for Velocity = V
    
a_0 = 0;    % Rail condition
da_0 = 0;   % Rail condition
[Calpha, CP] = barrowmanLift(Rocket,0,Velocity/346,0); % No roll
[CNa, Xp] = normalLift(Rocket,0,1.1,Velocity/346,0,0);
C1 = CorrectionMoment(Rocket,CNa,Xp,Velocity);
C2 = DampingMoment(Rocket,Calpha,CP,Velocity);

% 1.1 Wind disturbance:
Ms = C1*atan(V_inf/Velocity);

% 1.2 Solutions:
damp = C1/Rocket.rocket_I - C2^2/4/Rocket.rocket_I^2; % Damping ratio
if damp > 0
    w = sqrt(damp);
    D = C2/Rocket.rocket_I/2;
    phi = atan(w/D);
    A = - Ms/C1/sin(phi);
    a = @(t) A*exp(-D*t).*sin(w*t+phi)+Ms/C1;
elseif damp == 0
    w = sqrt(damp);
    D = C2/Rocket.rocket_I/2;
    A1 = -Ms/C1;
    A2 = -D*Ms/C1;
    a = @(t) (A1+A2*t)*exp(-D*t)+Ms/C1;
elseif damp <= 0
    tau1 = 1/(C2/2/Rocket.rocket_I-sqrt(-damp));
    tau2 = 1/(C2/2/Rocket.rocket_I+sqrt(-damp));
    A1 = -Ms*tau1/(tau1-tau2)/C1;
    A2 = Ms*tau2/(tau1-tau2)/C1;
    a = @(t) A1*exp(-t/tau1)+A2*exp(-t/tau2)+Ms/C1;
end

% 1.3 Max of Amplitude
sol = a(t);
Amplitude = [Amplitude max([max(sol) -min(sol)])];
figure (1);
plot(t,sol*180/pi,'r');grid on;
end

% 1.4 Results:
figure(2);
plot(V,Amplitude/pi*180,'r');hold on;grid on;
xlabel('Velocity [m/s]');ylabel('Amplitude of oscillation [deg]');
title('Amplitude vs Velocity at rail exit')

%--------------------------------------------------------------------------
% 2 Equation: Id2a/dt2+C2da/dt+C1a = delta(0) without Roll (Decoupled Equ.)
%--------------------------------------------------------------------------