function Y = SimAPI(SimObj, Xid, Yid, X)
%SIMAPI evaluates the simulator using the given parameters.
%   INPUTS: 
%       SimObj      Simulator object containing the base values of the parameters
%       Xid         IDs of the parameters that will change during the SA.
%       Yid         IDs of the desired outputs
%       X           Values of the parameter corresponding to Xid (one sample per column)
%   OUTPUT:
%       Y           Outputs corresponding to Yid (one output set per column)

% Implemented outputs
Yim_rail = ["Veor"];
Yimp_apogee = ["apogee" "t@apogee" "Vmax" "Vmax@t" "Cdmax" "a_max" "margin_min" "CNa_min" "MarCNa_min" "MarCNa_av"];
Yimp_landing = ["landing_azi" "landing_drift"];

if ~(any(ismember(Yid, Yimp_landing)) || any(ismember(Yid, Yimp_apogee)) || any(ismember(Yid, Yimp_landing)))
    print("Error: no given output id is implemented");
end

% Running the code
o = length(Yid);
N = size(X,2);
Y = NaN(o, N);


parfor idx_sim = 1:N
    % Time 
    t_s0 = tic;

    % Set parameters
    SimObj_i = setParam(SimObj, Xid, X(:, idx_sim));
    
    % Rail simulation
    [T1, S1] = SimObj_i.RailSim();
    
    if any(ismember(Yid, Yimp_apogee)) || any(ismember(Yid, Yimp_landing))
        % Thrust phase
        [T2_1, S2_1, ~, ~, ~] = SimObj_i.FlightSim([T1(end) SimObj_i.Rocket.Burn_Time(end)], S1(end, 2));
        
        % Ballistic phase
        [T2_2, S2_2, ~, ~, ~] = SimObj_i.FlightSim([T2_1(end) 40], S2_1(end, 1:3)', S2_1(end, 4:6)', S2_1(end, 7:10)', S2_1(end, 11:13)');
        
        T2 = [T2_1; T2_2(2:end)];
        S2 = [S2_1; S2_2(2:end, :)];
        T_1_2 = [T1;T2];
        S_1_2 = [S1;S2(:,3) S2(:,6)];
    end
    
    if any(ismember(Yid, Yimp_landing))
        % Drogue parachut descent 
        [T3, S3, ~, ~, ~] = SimObj_i.DrogueParaSim(T2(end), S2(end,1:3)', S2(end, 4:6)');
        % Main parachute descent
        [~, S4, ~, ~, ~] = SimObj_i.MainParaSim(T3(end), S3(end,1:3)', S3(end, 4:6)');
    end
    
    % Extracting the outputs into the output matrix
    for i=1:o
        id = Yid(i);
        switch id
            case "Veor"
                Y(i,idx_sim) = S1(end,2);
            case "apogee" 
                Y(i,idx_sim) = S2(end,3);
            case "t@apogee" 
                Y(i,idx_sim) = T2(end);
            case "Vmax" 
                Y(i,idx_sim) = max(S2(:,6));
            case "Vmax@t" 
                [~, tvmax] = max(S2(:,6));
                Y(i,idx_sim) = tvmax;
            case "Cdmax" 
                Y(i,idx_sim) = max(SimObj_i.SimAuxResults.Cd);
            case "a_max" 
                Y(i,idx_sim) = max(diff(S_1_2(:,2))./diff(T_1_2));
            case "margin_min" 
                Y(i,idx_sim) = min(SimObj_i.SimAuxResults.Margin);
            case "CNa_min"
                Y(i,idx_sim) = min(SimObj_i.SimAuxResults.Cn_alpha);
            case "MarCNa_min"
                Y(i,idx_sim) = min(SimObj_i.SimAuxResults.Margin.*SimObj_i.SimAuxResults.Cn_alpha);
            case "MarCNa_av"
                Y(i,idx_sim) = mean(SimObj_i.SimAuxResults.Margin.*SimObj_i.SimAuxResults.Cn_alpha);
            case "landing_drift"
                Y(i,idx_sim) = sqrt(S4(end,1).^2 + S4(end,2).^2);
            case "landing_azi"
                if (S4(:,1) == 0)
                    Y(i,idx_sim) = mod(sign(S4(end,2)) * 90, 360);
                else
                    Y(i,idx_sim) = mod(atand(S4(end,2)/S4(end,1)) - 90*(sign(S4(end,1)) - 1) + 180, 360);
                end
            otherwise
                error("Error: the output " + id + " is not implemented");
        end
    end
    %Time
    if mod(idx_sim, 1) == 0
         disp("     Simulation " +  num2str(idx_sim) + "/" + num2str(N) + " done. [" + num2str(toc(t_s0)) + " s]");
    end
end

