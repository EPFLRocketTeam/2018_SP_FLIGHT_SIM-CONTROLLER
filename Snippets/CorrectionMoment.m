function C1 = CorrectionMoment(t,Rocket,CNa,Xp,Velocity)
% Give the corrective moment based on rocket geometry
%

%--------------------------------------------------------------------------
% 1 Intrasic parameter
%--------------------------------------------------------------------------
rho = 1.22; % Air density at launch pad [kg/m3]
cm = CM(t,Rocket);

%--------------------------------------------------------------------------
% 2 Total Damping Coefficient
%--------------------------------------------------------------------------
C1 = 1/2*rho*Rocket.Sm*Velocity^2*CNa*(Xp-cm);

end

