function C1 = CorrectionMoment(t,Rocket,CNa,Xp,Velocity)
% Give the corrective moment based on rocket geometry
%

%--------------------------------------------------------------------------
% 1 Intrasic parameter
%--------------------------------------------------------------------------
rho = 1.22; % Air density at launch pad [kg/m3]
[M,dMdt,Cm,dCmdt,I_L,dI_Ldt,I_R,dI_Rdt] = Mass_Properties(t,Rocket,'Linear');

%--------------------------------------------------------------------------
% 2 Total Damping Coefficient
%--------------------------------------------------------------------------
C1 = 1/2*rho*Rocket.Sm*Velocity^2*CNa*(Xp-Cm);

end

