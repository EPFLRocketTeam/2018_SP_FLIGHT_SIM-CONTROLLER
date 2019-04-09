% Adding path to functions and declarations
addpath(genpath('Declarations'),...
        genpath('Functions'));

Rocket = rocketReader('Rocket_Definition_Mat_III_WindTunnel.txt');
Environnement = environnementReader('Environnement_Definition_WT.txt');

    
alpha = 9.5/180*pi; % Angle de la fusée
V_inf = 80; % Vitesse du vent
gamma = 1.4;
r = 287; % Constante des gaz parfaits ajustée pour l'air
T = 294; % Température en K
a = sqrt(gamma*r*T); % Vitesse du son
nu = interp1(Environnement.T_Nu',Environnement.Viscosity',[T]); % Viscosité
M = V_inf/a; % Nombre de Mach
K = 1.1; % Coefficient correctif pour le modèle de portance des tubes
rho = 1.120; % Densité

phi_set = 0;
phi_effect = interp1([0, 36000], [-190, 1.65], phi_set, 'linear');

C_Dab = []; C_D = []; F_Dab = []; F_D = []; C_Na = []; F_N = []; F_y = []; F_z = [];
for v=[20,30,40,50,60,70,80]
    M = v/a; % Nombre de Mach
    c_Dab = drag_shuriken(Rocket, phi_effect, alpha, v, nu);
    C_Dab = [C_Dab ; c_Dab];
    c_D = drag(Rocket, alpha, v, nu, a);
    C_D = [C_D ; c_D];
    f_Dab = 0.5*c_Dab*rho*pi*Rocket.dm^2/4*v^2;
    F_Dab = [F_Dab ; f_Dab];
    f_D = 0.5*c_D*rho*pi*Rocket.dm^2/4*v^2;
    F_D = [F_D ; f_D];
    c_Na = normalLift(Rocket, alpha, K, M, 0, 1);
    C_Na = [C_Na ; c_Na];
    f_N = 0.5*c_Na*alpha*rho*pi*Rocket.dm^2/4*v^2;
    F_N = [F_N ; f_N];
    F_y = [F_y ; f_D*sin(alpha)+f_N];
    F_z = [F_z ; f_D*cos(alpha)+f_Dab];
end
F = [F_N,F_y,F_z];
% C_Dab = drag_shuriken(Rocket, phi_effect, alpha, V_inf, nu)
% % phi_effect = 60;
% %     C_Dab = drag_flaps(Rocket, phi_effect, alpha, V_inf, nu)
% % C_Dab = 0;
% C_D = drag(Rocket, alpha, V_inf, nu, a)
% F_Dab = 0.5*C_Dab*rho*pi*Rocket.dm^2/4*V_inf^2
% F_D = 0.5*C_D*rho*pi*Rocket.dm^2/4*V_inf^2
% C_Na = normalLift(Rocket, alpha, K, M, 0, 1)
% F_N = 0.5*C_Na*alpha*rho*pi*Rocket.dm^2/4*V_inf^2
% F_y = F_D*sin(alpha)+F_N
% F_z = F_D*cos(alpha)+F_Dab