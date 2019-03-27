% Equations from Mandell
rho =  1.2; % density 
mu =  1.8e-5;  % dynamic viscosity 
C = 340; %speed of sound dry air 15C sea level
V = 200;   %ms-1 Mag of  characteristic velocity at center of pressure location 
M = V/C;
alpha = 0.1;

% Approx laminar flow over rocket

%% Rocket dimensions 
L = 2.5; 
L_cone = 0.50;
L_cyl = 2;
D_cyl = 0.12;
R_cyl = 0.06;

%Fin Geometry
fin.n=3;
fin.sweep = 0.06;
fin.h = 0.11;
fin.topchord = 0.12;
fin.basechord = 0.24;
fin.t = 0.003;
fin.a_ref = fin.n*fin.h*fin.t;
fin.area = (fin.topchord+fin.basechord)/2*fin.h;
fin.a_wet = fin.n*2*fin.area;
fin.c = (fin.topchord+fin.basechord)/2;
fin.X_b =  L - fin.basechord; % fin location

%A_ref
A_ref = pi*R_cyl^2;

F_ratio = L / D_cyl;


%%
R_ogive = (L_cone^2+ D_cyl^2/4)/D_cyl;
%A_wet

fun = @(x) 2*pi*(sqrt(R_ogive^2 - power((L_cone - x),2))+R_cyl-R_ogive);

A_wet =  integral(fun, 0, L_cone);

A_wet = A_wet + 2*pi*R_cyl*L_cyl; 

A_pin = 5e-5;

%% Assigning to equations as discribes in mandell
l_n = L_cone;

d_n = D_cyl;
d_b = D_cyl;
d_f = D_cyl;
d_d = D_cyl;
l_c  = 0; % no btail
l_b = L_cyl+L_cone;
Re_cb = 5e5;
Re_cf = 5e6;
T_f = fin.t;
l_TR = L;
n=fin.n;
% mid chord sweep

temp.x1 = fin.h*tan(fin.sweep);

temp.x2 = temp.x1 + fin.topchord - fin.basechord;

fin.sweepc = atan2((fin.basechord/2 + (temp.x2-fin.topchord/2)),fin.h);

clear temp fun fun2
l_m = fin.h/acos(fin.sweepc); % length midchord

A_fe= (fin.topchord+fin.basechord)/2*fin.h;

A_fp = A_fe + 0.5*d_f*fin.basechord;

%% ------Viscous Friction------
% Viscous friction ROCKET FORBODY Cf
Re  = rho*V*l_b/mu;
B = Re_cb(0.074/Re^(0.2) - 1.328/sqrt(Re));

if (Re < Re_cb)
    Cf =  1.328/sqrt(Re);
else
    Cf=0.074/Re^(0.2)-B/Re;
end

%  Viscous friction ROCKET FINS Cf_f
Re_f  = rho*V*fin.c/mu;  %Note the V is at the cop not the fin need to recalculate for better results 

B_f = Re_cf*(0.074/Re_f^(0.2) - 1.328/sqrt(Re_f));

if (Re_f < Re_cf)
    Cf_f =  1.328/sqrt(Re_f);
else
    Cf_f=0.074/Re_f^(0.2)-B_f/Re_f;
end

%% -------Drag at zero AoA-------
% Body drag, Box Eq41
Cd_fb = (1 + 60/(l_TR/d_b)^3+0.0025*l_b/d_b)*(2.7*l_n/d_b +4*l_b/d_b + 2*(1-d_d/d_b)*l_c/d_b)*Cf;
% Base drag, Box Eq42
Cd_b = 0.029*(d_d/d_b)^3/sqrt(Cd_fb);
% Fin drag, Box Eq44
Cd_f = 2*Cf_f *(1+2*T_f/fin.c)*4*n*A_fp/(pi*d_f^2);
% Interference drag, Box Eq44
Cd_i = 2*Cf_f*(1+2*T_f/fin.c)*4*n*(A_fp-A_fe)/(pi*d_f^2);
% Total drag coefficient at zero angle of attack
Cd0 = Cd_fb + Cd_b + Cd_f + Cd_i;

% Drag of camera shell -> base drag and front drag of faring(0.07)
%A_cam = 142e-6;
%Cd_cam = (0.12 + 0.13*(M)^2 + 0.07)*A_cam/A_ref;

% Launch pin drag % estimated from Mandell 
Cd_pin = 2*0.8*A_pin/A_ref; 
Cd0 = Cd0 + Cd_pin;
% compressibility correction
%% -------Additional drag at AoA-------

% Coefficients delta dn eta from windtunnel experiments, See Box p13
deltaktab=[4 6 8 10 12 14 16 18 20;0.78 0.86 0.92 0.94 0.96 0.97 0.975 0.98 0.982];
etatab=[4 6 8 10 12 14 16 18 20 22 24;0.6 0.63 0.66 0.68 0.71 0.725 0.74 0.75 0.758 0.77 0.775];
% error in paper
etak=interp1(etatab(1,:),etatab(2,:),F_ratio,'linear','extrap');
deltak=interp1(deltaktab(1,:),deltaktab(2,:),F_ratio,'linear','extrap');
if etak>1
    etak=1;
end
if deltak>1
    deltak=1;
end
% Body drag at angle alpha
Cd_b_alpha = 2*deltak*alpha^2 + 3.6*etak*(1.36*l_TR - 0.55*l_n)*alpha^3/(pi*d_b);
% Fin body interference coefficients
Rs = R_cyl/(R_cyl+fin.h);
Kbf=0.8065*Rs^2+1.1553*Rs;
Kfb=0.1935*Rs^2+0.8174*Rs+1;
% Fin drag at angle alpha
CDi = (1.2*A_fp*4/(pi*d_f^2))*alpha^2;
DCDi = (3.12*(Kfb +Kbf-1)*A_fe*4/(pi*d_f^2))*alpha^2;
Cd_f_alpha =  CDi + DCDi;

%% -------Totol Drag Coefficient-------
Cd = Cd0 + Cd_b_alpha + Cd_f_alpha;
Cd = Cd/sqrt(1-M^2);