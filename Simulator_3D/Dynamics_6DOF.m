function S_dot = Dynamics_6DOF(t, s, Rocket, Environment)

X = s(1:3);
V = s(4:6);
Q = s(7:10);
W = s(11:13);

%% Coordinate systems

% Rotation matrix from rocket coordinates to Earth coordinates
C = quat2rotmat(Q');
angle = rot2anglemat(C);

% Rocket principle frame vectors expressed in earth coordinates
YA = C*[1,0,0]'; % Yaw axis
PA = C*[0,1,0]'; % Pitch Axis
RA = C*[0,0,1]'; % Roll Axis

% Earth coordinate vectors expressed in earth's frame
XE = [1, 0, 0]';
YE = [0, 1, 0]';
ZE = [0, 0, 1]';

%% Rocket Inertia
[Mass,dMdt] = Mass_Lin(t,Rocket); % mass
I_L = Inertia(t, Rocket);
I = diag([I_L, I_L, 1]); % Inertia (TODO: Calculate variable inertia)
                                                 % (TODO: Include rotational inertia)

%% Environment
g = 9.81;               % Gravity [m/s2] 
[Temp, a, p, rho] = stdAtmos(X(3)); % Atmosphere information (TODO: Include effect of humidity and departure altitude)

%% Force estimations 

% Thrust
% Oriented along roll axis of rocket frame, expressed in earth coordinates. 
T = Thrust(t,Rocket)*RA; % (TODO: Allow for thrust vectoring -> error)

% Gravity
G = -g*Mass*ZE;

% Aerodynamic corrective forces
% Compute center of mass angle of attack
Vcm = V - Environment.V_inf*XE; % (TODO: Allow for any wind direction)
Vcm_mag = norm(Vcm);
alpha_cm = atan2(norm(cross(RA, Vcm)), dot(RA, Vcm));

% Mach number
M = Vcm_mag/a;
% normal lift coefficient and center of pressure
[CNa, Xcp] = normalLift(Rocket, alpha_cm, 1.1, M, angle(3), 1);
% stability margin
margin = (Xcp-CM(t, Rocket));

% Compute apparent velocity of center of mass
Wnorm = W/norm(W);
if(isnan(Wnorm))
    Wnorm  = zeros(3,1);
end
Vrel = Vcm + margin*sin(acos(dot(RA,Wnorm)))*(cross(RA, W));
Vmag = norm(Vrel);
Vnorm = Vrel/norm(Vrel);

% angle of attack 
Vcross = cross(RA, Vnorm);
alpha = atan2(norm(cross(RA, Vnorm)), dot(RA, Vnorm));

% normal force
NA = cross(RA, Vcross); % normal axis
if norm(NA) == 0
    N = [0, 0, 0]'; 
else
    N = 0.5*rho*Rocket.Sm*CNa*alpha*Vmag^2*NA/norm(NA);
end

% Drag
% Drag coefficient
CD = drag(Rocket, alpha, Vmag, Environment.Nu, a); % (TODO: make air-viscosity adaptable to temperature)
% Drag force
D = -0.5*rho*Rocket.Sm*CD*Vmag^2*RA; % (TODO: define drag in wind coordinate system)

% Total forces
F_tot = ...
    T +...  % Thrust
    G +...  % gravity
    N +... % normal force
    D      ; % drag force

%% Moment estimation

%Aerodynamic corrective moment
if(norm(Vcross) == 0)
MN = zeros(3,1);    
else
MN = norm(N)*margin*Vcross/norm(Vcross); % (TODO: Allow cm to change with time)
end

M_tot = ...
    MN      ; % aerodynamic corrective moment

%% State derivatives

% Translational dynamics
X_dot = V;
V_dot = 1/Mass*(F_tot - V*dMdt);

% Rotational dynamics
Q_dot = quat_evolve(Q, W);
W_dot = I\(M_tot); % (TODO: Add inertia variation with time)

% Return derivative vector
S_dot = [X_dot;V_dot;Q_dot;W_dot];
end