function CDM = pitchDampingMoment(Rocket, rho, Calpha, CP, dMdt, CM, w, V)
% PITCHDAMPINGMOMENT computes the pitch damping moment coefficient of the
% rocket. It also applies to yaw damping, but not to roll!
% Damping is based on the rocket's geometry i.e the air resistance opposing
% its rotational movement and the mass change rate during the thrust phase.

    if V == 0
        CDM = 0;
    else
        % -------------------------------------------------------------------------
        % Thrust damping
        % -------------------------------------------------------------------------

        CDM_thrust = dMdt*(Rocket.L-CM).^2*w*2/V^2/rho/Rocket.Sm;

        % -------------------------------------------------------------------------
        % Aerdynamic damping
        % -------------------------------------------------------------------------

        %Method found in peak of flight news letter, indications towards an article
        %from Bryson, 1953, Stability Derivatives for a Slender Missile With
        %Application to a Wing- Body-Vertical-Tail Configuration,
        % or from Sacks, 1954, Aerodynamic forces, moments, and stability
        % derivatives for slender bodies of general cross section 
        %Aerodynamic damping coefficient
        CNa_Total = sum(Calpha.*(CP-CM).^2);
        % Total
        CDM_aero = CNa_Total*w/V;

%         % OpenRocket method, see OpenRocket documentation 3.2.3
%         % Damping coefficient relative to body
%         CDM_body = 0.275*Rocket.stage_z(end)^4/Rocket.Sm*w^2/V^2;
%         % Damping coefficient relative to fins
%         CDM_fin = 0.6*Rocket.fin_n*Rocket.fin_SE*(Rocket.fin_xt-CM)^3/Rocket.Sm/Rocket.dm*w^2/V^2;
%         % Total
%         CDM_aero = CDM_body + CDM_fin;

        % -------------------------------------------------------------------------
        % Total damping
        % -------------------------------------------------------------------------
        CDM = CDM_aero + CDM_thrust;
    end
end