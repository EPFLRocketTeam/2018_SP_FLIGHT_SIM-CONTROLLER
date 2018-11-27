% ANALYTICAL TABLE 2DOF
% 
% Script estimating airbrake deployment based on 2 variables, altitude and
% flight speed. Trajectory equations were determined analytically based on
% free flight equations based on constant drag coefficient and environment.
% The equations are inverted such that the knowledge of the apogee,
% altitude values where data is desired and braking values are known. 
%
% Date : 12.03.2018
% Author : Eric Brunner

% -------------------------------------------------------------------------
% 0. Initialization
% -------------------------------------------------------------------------

clear all;
close all;

% -------------------------------------------------------------------------
% 1. Parameter defintion
% -------------------------------------------------------------------------

% 1.1 Rocket
Rocket = rocketReader('Rocket_Definition.txt');
Uinf = 200;

% 1.2 Environment
Env.rho = 1.2;
Env.nu = 1.5e-5;
Env.a = 345;
Env.g = 9.81;

% 1.3 Parameter range
x0 = linspace(1000, 3048, 100);

% 1.4 rocket body drag at 0 AoA and at arbitrary (relatively high velocity)
CD0_body = drag(Rocket, 0, Uinf, Env.nu, Env.a);

% 1.5 airbrake drag
% 1.5.1 control range
n_theta = 5;
theta_tab = linspace(-190.5, 1.165, n_theta);
% 1.5.2 drag values
CDab = zeros(1, length(theta_tab));
for i = 1:length(theta_tab)
    CDab(i) = drag_shuriken(Rocket, theta_tab(i), 0, Uinf, Env.nu);
end

% 1.6 target apogee
apogee = 3048;

% -------------------------------------------------------------------------
% 2. Compute control table
% -------------------------------------------------------------------------

x0_ext = kron(x0, ones(1, length(CDab)));
CDab_ext = kron(ones(1, length(x0)), CDab);
theta_ext = kron(ones(1, length(x0)), theta_tab);
Vinf_ext = sqrt(2*Rocket.rocket_m*Env.g./Env.rho./Rocket.Sm./(CD0_body + CDab_ext));
v0_ext = Vinf_ext.*tan(acos(exp(Env.g./Vinf_ext.^2.*(x0_ext-apogee))));

% -------------------------------------------------------------------------
% 3. Write control table to csv file
% -------------------------------------------------------------------------

csvwrite('Control_Table', [x0_ext', v0_ext', theta_ext']);

% -------------------------------------------------------------------------
% 4. Plot graphs
% -------------------------------------------------------------------------

figure; hold on;
for i = 1:n_theta
    mask = zeros(1,n_theta);
    mask(i) = 1;
    v_tmp = v0_ext(find(kron(ones(1, length(x0)), mask)));
    plot(x0, v_tmp, 'DisplayName', ['theta = ' num2str(theta_tab(i))]); 
end
axis([1000 3100 0 250]);
legend show;