function C1 = CorrectionMoment(t,Rocket,CNa,Xp,Velocity,Environnement,Altitude)
% Give the corrective moment based on rocket geometry
%

%--------------------------------------------------------------------------
% 1 Intrasic parameter
%--------------------------------------------------------------------------
[T, a, p, rho, Nu] = stdAtmos(Altitude,Environnement);
<<<<<<< HEAD
[M,dMdt,Cm,dCmdt,I_L,dI_Ldt,I_R,dI_Rdt] = Mass_Properties(t,Rocket,'Linear');
=======
[M,dMdt,Cm,dCmdt,I_L,dI_Ldt,I_R,dI_Rdt] = Mass_Properties(t,Rocket,'NonLinear');
>>>>>>> 51e7e0c3254bfa5d398b0c36bd1cb48bd4bde0e8

%--------------------------------------------------------------------------
% 2 Total Damping Coefficient
%--------------------------------------------------------------------------
C1 = 1/2*rho*Rocket.Sm*Velocity^2*CNa*(Xp-Cm);

end

