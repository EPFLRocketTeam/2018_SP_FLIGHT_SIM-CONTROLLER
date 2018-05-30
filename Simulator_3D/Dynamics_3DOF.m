function S_dot = Dynamics_3DOF(t, s, Rocket, Environment)

X = s(1:3);
V = s(4:6);

% Earth coordinate vectors expressed in earth's frame
XE = [1, 0, 0]';
YE = [0, 1, 0]';
ZE = [0, 0, 1]';

% atmosphere
[~, a, ~, rho, nu] = stdAtmos(X(3)+Environment.Start_Altitude, Environment);

% mass
M = Rocket.rocket_m;

V_rel = V -...
     ... % Wind as computed by windmodel
    windModel(t, Environment.Turb_I,Environment.V_inf*Environment.V_dir,...
    Environment.Turb_model);

% gravity
% Gravity
G = -9.81*M*ZE;
% Drag
% Drag coefficient
CD = drag(Rocket, 0, norm(V_rel), nu, a); % (TODO: make air-viscosity adaptable to temperature)
% Drag force
D = -0.5*rho*Rocket.Sm*CD*V_rel*norm(V_rel); 

% Translational dynamics
X_dot = V;
V_dot = 1/M*(D + G);

S_dot = [X_dot; V_dot];

end