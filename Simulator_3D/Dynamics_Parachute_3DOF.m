function dsdt = Dynamics_Parachute_3DOF(t,s, Rocket, Environment, M, Main)

X = s(1:3);
V = s(4:6);

% Atmospheric Data
[~, ~, ~, rho] = stdAtmos(X(3)+Environment.Start_Altitude); % Atmosphere [K,m/s,Pa,kg/m3]

% Aerodynamic force
Vrel = -V + ...
     ... % Wind as computed by windmodel
    windModel(t, Environment.Turb_I,Environment.V_inf*Environment.V_dir,...
    Environment.Turb_model);

if Main
    SCD = Rocket.para_main_SCD;
elseif Main == 0
    SCD = Rocket.para_drogue_SCD;
end
D = 0.5*rho*SCD*norm(Vrel)*Vrel;

% Gravity force
g = 9.81*[0;0;-1];
G = g*M;

dXdt = V;
dVdt = (D+G)/M;

dsdt = [dXdt; dVdt];
end