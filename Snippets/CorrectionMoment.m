function C1 = CorrectionMoment(t,Rocket,CNa,Xp,Velocity,Environnement,Altitude)
% Give the corrective moment based on rocket geometry
%

%--------------------------------------------------------------------------
% 1 Intrasic parameter
%--------------------------------------------------------------------------
[T, a, p, rho, Nu] = stdAtmos(Altitude,Environnement);
[M,dMdt,Cm,dCmdt,I_L,dI_Ldt,I_R,dI_Rdt] = Mass_Properties(t,Rocket,'NonLinear');

%--------------------------------------------------------------------------
% 2 Total Damping Coefficient
%--------------------------------------------------------------------------
C1 = 1/2*rho*Rocket.Sm*Velocity^2*CNa*(Xp-Cm);

end

