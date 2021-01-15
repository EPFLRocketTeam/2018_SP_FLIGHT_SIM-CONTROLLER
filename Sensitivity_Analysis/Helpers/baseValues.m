 function XX = baseValues(SimObj, Xid, s)
%BASEVALUES extracts the parameters of the already existing SimObj and return the domain
%of definition of each value (i.e. the domain in which it can variate for the SA).
%   INPUTS: 
%       SimObj      Simulator object containing the base values of the parameters
%       Xid         IDs of the parameters that will change during the SA.
%       s           Relative size of the the domain of definition (i.g. if x0 is the base
%                   value of parameter x, then x will take value in [a, b] with
%                   a=x0(1-s) and b=x0(1+s). Hence, 0<=s<1.
%   OUTPUT:
%       XX          Matrix that has one row of the form [x0 a b] for each parameter in
%                   Xid.

% Error management
if (s <= 0) || (s > 1)
    print("Warning: sigma out of bound (must be in [0, 1[).")
end

%TODO Check that the base values are correct

[rocketparamIDs, envparamIDs] = paramNames(SimObj);

% Initialazing
k = length(Xid);
XX = NaN(k, 3);

for i=1:k
    id = Xid(i);
    
    switch id
        case "dmin"
            XX(i,1) = SimObj.Rocket.("diameters")(end);
        case "dd"
            XX(i,1) = max(SimObj.Rocket.("diameters")) - SimObj.Rocket.("diameters")(end);
        case "z1"
            XX(i,1) = SimObj.Rocket.("stage_z")(2);
        case "z12"
            XX(i,1) = SimObj.Rocket.("stage_z")(3) - SimObj.Rocket.("stage_z")(2);
        case "z23"
            XX(i,1) = SimObj.Rocket.("stage_z")(4) - SimObj.Rocket.("stage_z")(3); 
        case "T1"
            XX(i,1) = SimObj.Rocket.("Thrust_Force")(2); 
        case "T2"
            XX(i,1) = SimObj.Rocket.("Thrust_Force")(3);
        case "Vi1"
            XX(i,1) = SimObj.Environment.("Vspeed")(2);
        case "Vi2"
            XX(i,1) = SimObj.Environment.("Vspeed")(11);
        case "Vi3"
            XX(i,1) = SimObj.Environment.("Vspeed")(16);
        case "Vi4"
            XX(i,1) = SimObj.Environment.("Vspeed")(51);
        case "Vi5"
            XX(i,1) = SimObj.Environment.("Vspeed")(101);
        case "Vi6"
            XX(i,1) = SimObj.Environment.("Vspeed")(201);
        case "ai1"
            XX(i,1) = SimObj.Environment.("Vazy")(2);
        case "ai2"
            XX(i,1) = SimObj.Environment.("Vazy")(11);
        case "ai3"
            XX(i,1) = SimObj.Environment.("Vazy")(16);
        case "ai4"
            XX(i,1) = SimObj.Environment.("Vazy")(51);
        case "ai5"
            XX(i,1) = SimObj.Environment.("Vazy")(101);
        case "ai6"
            XX(i,1) = SimObj.Environment.("Vazy")(201);
        otherwise
            if ismember(id, rocketparamIDs)
                XX(i,1) = SimObj.Rocket.(id);
            elseif ismember(id, envparamIDs)
                XX(i,1) = SimObj.Environment.(id);
            else
                print("Error: unknown parameter (", id, ")");
            end
    end
end

% Compute the intervals
XX(:,2) = (1-s)*XX(:,1);
XX(:,3) = (1+s)*XX(:,1);

% Checking the physical conditions
if SimObj.Rocket.stage_z(3)*(1-s) < (SimObj.Rocket.fin_cr + SimObj.Rocket.fin_xt)*(1+s)
    disp("Warning: the fins might be two far back compared to the length of the rocket (unrealistic configuration). Decrease sigma.");
if SimObj.Rocket.stage_z(3)*(1-s) < SimObj.Rocket.ab_x*(1+s)
    disp("Warning: the airbrakes might be two far back compared to the length of the rocket (unrealistic configuration). Decrease sigma."); 
end

end

