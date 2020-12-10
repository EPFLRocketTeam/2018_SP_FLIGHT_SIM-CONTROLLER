function CD = drag(Rocket, alpha, Uinf, nu, a)
% DRAG - Rocket drag calculation function based on Mandell's book "Topics
% on advanced model Rocketry" (unless otherwise specified). 
% LIMITATIONS:
% - Isn't usable for very low speeds (<0.1m/s)
% - Input velocity must be > 0
% INPUTS:
% - Rocket  : Rocket object
% - alpha   : angle of attack [rad]
% - Uinf    : Free stream velocity [m/s]
% - nu      : Dynamic viscosity [m2/s]
% - a       : Speed of sound [m/s]
% OUTPUTS:
% - CD      : Drag coefficient
% REFERENCES:
% - Gordon K. Mandell, Topics in Advanced Model Rocketry, MIT Press, 1973
% - Hassan Arif, Identification and Control of a High Power Rocket, EPFL
% Semester Project Report, Professor Collin Jones, June 2017.

% -------------------------------------------------------------------------
% 0. Divergence 
% -------------------------------------------------------------------------
if Uinf < 0.1
    Uinf = 0.1;
end
% -------------------------------------------------------------------------
% 1. Geometrical Parameters
% -------------------------------------------------------------------------

dm = Rocket.dm; % maximum rocket diameter 
Sm = Rocket.Sm; % maximum cross-sectional body area
% c = Rocket.fin_c; % fin cord
% SE = Rocket.fin_SE; % Exposed planform fin area
% df = Rocket.fin_df; % body diameter at middle of fin station
% SF = Rocket.fin_SF; % Virtual fin planform area

% -------------------------------------------------------------------------
% 2. Reynolds Numbers (eq 191, p 458)
% -------------------------------------------------------------------------

% 2.1 Body 
Rl = Rocket.stage_z(end)*Uinf/nu; 
Rl_crit = 5e5;
% % 2.2 Fins
% Rc = c*Uinf/nu; 
% Rc_crit = 5.14e6;
% Critical values of the Reynolds number are selected as shown in Fig. 51,
% p.464


% -------------------------------------------------------------------------
% 3. Skin Friction Coefficients
% -------------------------------------------------------------------------

% 3.1 Body skin friction
% 3.1.1 turbulent skin friction for a flat plate (eq 102a, p 357)
Cf_turb_B = 0.074/(Rl)^0.2;
% 3.1.2 laminar skin friction for a flat plate (eq 102b, p 357)
Cf_lam_B = 1.328/sqrt(Rl); 
% 3.1.3 transitional flow factor for a flat plate (eq 100, p 356)
B_B = Rl_crit*(Cf_turb_B - Cf_lam_B);
% 3.1.4 transitional skin friction for body (eq 101, p 356)
Cf_turb_B = Cf_turb_B-B_B/Rl; 

% % 3.2 Fin skin friction
% % 3.2.1 turbulent skin friction for a flat plate (eq 102a, p 357)
% Cf_turb_F = 0.074/(Rc)^0.2; 
% % 3.2.2 laminar skin friction for a flat plate (eq 102b, p 357)
% Cf_lam_F = 1.328/sqrt(Rc);
% % 3.2.3 transitional flow factor for a flat plate (eq 100, p 356)
% B_F = Rc_crit*(Cf_turb_F - Cf_lam_F); 
% % 3.2.4 transitional skin friction for body (eq 101, p 356)
% Cf_turb_F = Cf_turb_F-B_F/Rc; 


% -------------------------------------------------------------------------
% 4. 0?? AoA drag
% -------------------------------------------------------------------------

% 4.1 Wetted area ratio
% 4.1.1 ogive cone (eq 171c, p 439)
% 4.1.2 boattail cone (eq 172a, p 441)64 TER
SsSm = 2/dm^2*sum((Rocket.diameters(2:end-1)+ Rocket.diameters(3:end)).*...
    (Rocket.stage_z(3:end)-Rocket.stage_z(2:end-1)).*...
    sqrt(1+((Rocket.diameters(2:end-1) - Rocket.diameters(3:end))./2./...
    (Rocket.stage_z(3:end)-Rocket.stage_z(2:end-1))).^2)); 
if strcmp(Rocket.cone_mode, 'on')
    SsSm = SsSm + 2.67*Rocket.stage_z(2)/dm;
end

if Rocket.stage_z(2)/dm < 1.5
    display('WARNING: In drag coefficient calculation, ogive cone ratio is out of bounds. Drag estimation cannot be trusted.');
end

% 4.2 Body drag
% 4.2.1 (eq 161, p 431)
CDf_B = (1+60/(Rocket.stage_z(end)/dm)^3+0.0025*(Rocket.stage_z(end)/dm))*SsSm; % partially calculated body drag
if Rl < Rl_crit
    CDf_B = Cf_lam_B*CDf_B; % body drag for laminar flow
else
    CDf_B = Cf_turb_B*CDf_B; % body drag for turbulent flow
end
% 4.2.2 Base drag (eq 162, p 431)
CDb = 0.029*(Rocket.diameters(end)/dm)^3/sqrt(CDf_B);
% 4.2.3 Body drag at 0?? AoA (eq 160, p 431)
CD0_B = CDf_B +CDb; 

% 4.3 Fin drag
% 4.3.1 Fin drag at 0?? AoA (eq 159, p 433)
% CD0_F = 2*(1+2*Rocket.fin_t/c)*Rocket.fin_n*SF/Sm; 
% if Rc < Rc_crit
%     CD0_F = CD0_F*Cf_lam_F;
% else
%     CD0_F = CD0_F*Cf_turb_F;
% end
CD0_F = 0;

% 4.4 Launch lug drag mounted on body (eq 119 p 390)
% TODO consider launch lugs mounted near fins with a different drag
% coefficient.
CD_l = Rocket.lug_n*5.75*Rocket.lug_S/Sm;

% 4.5 Fin and Body drag at 0 AoA (eq 158, p 430) plus launch lug drag
CD0_FB = CD0_B + CD0_F + CD_l;

% 4.6 Drag for nosecone failure
if strcmp(Rocket.cone_mode, 'off')
   CD0_FB = CD0_FB + 1 - CDf_B; 
end

% -------------------------------------------------------------------------
% 5. Drag at AoA
% -------------------------------------------------------------------------

% 5.1 Body drag at AoA
% 5.1.1 factor tables as seen in Fig. 35 and 36 on p. 405
alpha = abs(alpha);
etatab=[4 6 8 10 12 14 16 18 20 22 24;0.6 0.63 0.66 0.68 0.71 0.725 0.74 0.75 0.758 0.77 0.775];
deltaktab=[4 6 8 10 12 14 16 18 20;0.78 0.86 0.92 0.94 0.96 0.97 0.975 0.98 0.982];
etak = interp1(etatab(1,:),etatab(2,:),Rocket.stage_z(end)/dm,'linear','extrap');
deltak=interp1(deltaktab(1,:),deltaktab(2,:),Rocket.stage_z(end)/dm,'linear','extrap');
% 5.1.2 Compute body drag at angle of attack alpha
% 5.1.2.1 x1 as defined by explanations of (eq 140, p 404)
x1 = Rocket.stage_z(find(diff(Rocket.diameters)==0, 1, 'first'));
% 5.1.2.2 x0 as in (eq 140, p404)
x0 = 0.55*x1+0.36*Rocket.stage_z(end);
% 5.1.2.3 Section Area at station x0
S0 = pi*interp1(Rocket.stage_z, Rocket.diameters, x0, 'linear')^2/4;
% 5.1.2.4 Body drag at low AoA (eq 139, p. 404)
CDB_alpha = 2*deltak*S0/Sm*alpha*sin(alpha);
tmp_stages = [x0, Rocket.stage_z(Rocket.stage_z>x0)];
tmp_diameters = [interp1(Rocket.stage_z, Rocket.diameters, x0, 'linear'), Rocket.diameters(Rocket.stage_z>x0)];
% 5.1.2.4 Body drag at high AoA (eq 142, p. 406)
CDB_alpha = CDB_alpha + 2*alpha^2*sin(alpha)/Sm*etak*1.2*sum((tmp_diameters(1, end-1)+tmp_diameters(2:end))/2.*(tmp_stages(2:end)-tmp_stages(1:end-1)));

% % 5.2 Fin drag at AoA
% % 5.2.1 Fin Exposed Surface Coefficient
% % TODO: Consider rocket roll for lateral exposed fin surface
% FESC = 2;
% % 5.2.2 induced fin drag, similar to (eq 145, p 413)
% CDi = 1.2*alpha^2*SF/Sm*FESC;
% % 5.2.3 Interference coefficients as estimated by Hassan (eq 34 and 35, p
% % 12) based on Mandell Fig. 40 p 416.
% Rs = df/(2*Rocket.fin_s+df); % Total fin span ratio
% KFB = 0.8065*Rs^2+1.1553*Rs; % Interference of body on fin lift
% KBF = 0.1935*Rs^2+0.8174*Rs+1; % Interference of fins on body lift
% % 5.2.4 Interference Drag Coefficient (eq 146, p 415)
% DCDi = (KFB + KBF - 1)*3.12*SE/Sm*alpha^2*FESC; % Interference drag
% CDF_alpha = CDi + DCDi;
CDF_alpha = 0;

% 5.3 Total drag at AoA (eq 148, p 417)
CD_alpha = CDB_alpha + CDF_alpha;

% -------------------------------------------------------------------------
% 7. Drag of tumbeling body (c.f. OpenRocket Documentation section 3.5)
% -------------------------------------------------------------------------
% fin_efficiency = [0.5, 1, 1.5, 1.41, 1.81, 1.73, 1.9, 1.85];
% CD_t_fin = 1.42*fin_efficiency(Rocket.fin_n);
% CD_t_body = 0.56;

% CD_t = (SE*CD_t_fin+CD_t_body*dm*(Rocket.stage_z(end)-Rocket.stage_z(2)))/Sm;
CD_t = 0;

% -------------------------------------------------------------------------
% 6. Subsonic drag coefficient
% -------------------------------------------------------------------------
CD = CD0_FB + CD_alpha;
% the calculated drag can't be more than the lateral drag of a tumbling
% body so it is cut-off to that value if it is larger. 
if CD > CD_t
    CD = CD_t;
end

% -------------------------------------------------------------------------
% 7. Compressible flow correction factor (for a sharp nose) (eq 214, p 482)
% -------------------------------------------------------------------------
M = Uinf/a;
if M>0.9 && M<=1.05
    CD = CD*(1 + 35.5*(M-0.9)^2);
elseif M > 1.05 && M <=2
    CD = CD*(1.27+0.53*exp(-5.2*(M-1.05)));
elseif M > 2 && ~(M<=0.9)
    display('WARNING: In drag calculation, Mach number exceeds validity range.');
end

end