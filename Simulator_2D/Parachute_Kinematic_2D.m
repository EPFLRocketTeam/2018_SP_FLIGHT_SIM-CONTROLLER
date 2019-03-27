function dsdt = Parachute_Kinematic_2D(t,s, Rocket, Environment)

X = [s(1);s(3)];
V = [s(2);s(4)];

% Compute mass
[M,~] = Mass_Lin(t,Rocket);
M = M - Rocket.pl_mass;

% Atmospheric Data
[~, ~, ~, rho] = stdAtmos(X(2)); % Atmosphere [K,m/s,Pa,kg/m3]

% Aerodynamic force
Vrel = -V + Environment.V_inf*[1;0];
D = 0.5*rho*Rocket.SCD*norm(Vrel)*Vrel;

% Gravity force
g = 9.81*[0;-1];
G = g*M;

dXdt = V;
dVdt = (D+G)/M;

dsdt = [dXdt(1); dVdt(1); dXdt(2); dVdt(2)];
end