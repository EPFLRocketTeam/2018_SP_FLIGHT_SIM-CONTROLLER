function dCalpha2 = drobertGalejsLift_ddelta(Rocket, alpha, K)

    % cone
    Ap_cone = 0.5*Rocket.stage_z(2)*Rocket.diameters(2);
    Xp_cone = 2/3*Rocket.stage_z(2);

    % stages
    Ap_stage = zeros(1, Rocket.stages-2);
    Xp_stage = zeros(1, Rocket.stages-2);
    for i = 1:(Rocket.stages-2)
        Ap_stage(i) = (Rocket.diameters(i+1)+Rocket.diameters(i+2))/2*(Rocket.stage_z(i+2)-Rocket.stage_z(i+1));
        Xp_stage(i) = Rocket.stage_z(i+1)+1/3*(Rocket.stage_z(i+2)-Rocket.stage_z(i+1))*(Rocket.diameters(i+1)+2*Rocket.diameters(i+2))/(Rocket.diameters(i+1)+Rocket.diameters(i+2));
    end
    
    % Output
    dCalpha2 = 4/pi/Rocket.diameters(2)^2*K*[Ap_cone, Ap_stage];
end

