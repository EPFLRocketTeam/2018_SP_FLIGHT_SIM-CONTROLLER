function [Calpha2, Xp] = robertGalejsLift(Rocket, alpha, K)
    
    % cone
    if strcmp(Rocket.cone_mode, 'on')
        Ap_cone = 0.5*Rocket.stage_z(2)*Rocket.diameters(2);
        Xp_cone = 2/3*Rocket.stage_z(2);
    end

    % stages
    Ap_stage = zeros(1, Rocket.stages-2);
    Xp_stage = zeros(1, Rocket.stages-2);
    for i = 1:(Rocket.stages-2)
        Ap_stage(i) = (Rocket.diameters(i+1)+Rocket.diameters(i+2))/2*(Rocket.stage_z(i+2)-Rocket.stage_z(i+1));
        Xp_stage(i) = Rocket.stage_z(i+1)+1/3*(Rocket.stage_z(i+2)-Rocket.stage_z(i+1))*(Rocket.diameters(i+1)+2*Rocket.diameters(i+2))/(Rocket.diameters(i+1)+Rocket.diameters(i+2));
    end
    
    % Output
    Ap = Ap_stage;
    Xp = Xp_stage;
    if strcmp(Rocket.cone_mode, 'on')
        Ap = [Ap_cone, Ap];
        Xp = [Xp_cone, Xp];
    end
    Calpha2 = 4/pi/Rocket.diameters(2)^2*K*Ap*alpha;
end 