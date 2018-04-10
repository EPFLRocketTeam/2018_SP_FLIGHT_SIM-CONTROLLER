function S_dot = Dynamics_Rail_1DOF(t, s, Rocket, Environment)

x = s(1); % position
v = s(2); % speed

%% Rocket Inertia
[Mass,dMdt] = Mass_Non_Lin(t,Rocket); % mass

%% Environment
g = 9.81;               % Gravity [m/s2] 
[Temp, a, p, rho] = stdAtmos(x*sin(Environment.Rail_Angle)); % Atmosphere information (TODO: Include effect of humidity and departure altitude)

%% Force estimation

% gravity
G = -g*cos(Environment.Rail_Angle)*Mass;

% Thrust 
T = Thrust(t,Rocket); % (TODO: Allow for thrust vectoring -> error)

% drag
CD = drag(Rocket, 0, v, Environment.Nu, a); % (TODO: make air-viscosity adaptable to temperature)
D = -0.5*rho*Rocket.Sm*CD*v^2; % (TODO: define drag in wind coordinate system)

F_tot = G + T + D;

%% State derivatives

x_dot = v;
v_dot = 1/Mass*(F_tot - v*dMdt);

S_dot = [x_dot; v_dot];
end