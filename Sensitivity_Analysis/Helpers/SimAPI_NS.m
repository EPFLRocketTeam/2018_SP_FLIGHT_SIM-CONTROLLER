function [Y, T] = SimAPI_NS(SimObj, Xid, X)
%SIMAPI_NS evaluates the simulator using the given parameters and monitor the time of execution.
%   INPUTS: 
%       SimObj      Simulator object containing the base values of the parameters
%       Xid         IDs of the parameters that will change during the SA.
%       X           Values of the parameter corresponding to Xid (one sample per column)
%   OUTPUT:
%       Y           Outputs corresponding to Yid (one output set per column)
% .     T           Time of execution of each phase.


% Running the code
N = size(X,2);
Y = NaN(2, 3, N);
T = NaN(5, N);

disp("Simulator: " + class(SimObj));
for idx_sim = 1:N

    % Set parameters
    SimObj = setParam(SimObj, Xid, X(:, idx_sim));
    
    % Rail simulation
    % Time 
    t_R0 = tic;
    [T1, S1] = SimObj.RailSim();
    t_R = toc(t_R0);
    
    % Thrust phase
    t_A10 = tic;
    [T2_1, S2_1, ~, ~, ~] = SimObj.FlightSim([T1(end) SimObj.Rocket.Burn_Time(end)], S1(end, 2));
    t_A1 = toc(t_A10);
    
    % Ballistic phase
    t_A20 = tic;
    [T2_2, S2_2, ~, ~, ~] = SimObj.FlightSim([T2_1(end) 40], S2_1(end, 1:3)', S2_1(end, 4:6)', S2_1(end, 7:10)', S2_1(end, 11:13)');
    t_A2 = toc(t_A20);
    
    T2 = [T2_1; T2_2(2:end)];
    S2 = [S2_1; S2_2(2:end, :)];
    T_1_2 = [T1;T2];
    S_1_2 = [S1;S2(:,3) S2(:,6)];

    % Drogue parachut descent 
    t_D0 = tic;
    [T3, S3, ~, ~, ~] = SimObj.DrogueParaSim(T2(end), S2(end,1:3)', S2(end, 4:6)');
    t_D = toc(t_D0);
    
    % Main parachute descent
    t_M0 = tic;
    [~, S4, ~, ~, ~] = SimObj.MainParaSim(T3(end), S3(end,1:3)', S3(end, 4:6)');
    t_M = toc(t_M0);
    
    
    T(:, idx_sim) = [t_R, t_A1, t_A2, t_D, t_M];
    Y(1, :, idx_sim) = S2(end,1:3)'; %position apogee
    Y(2, :, idx_sim) = S4(end,1:3)'; %position landing
    
    disp("Simulation " + num2str(idx_sim) + "/" + num2str(N) + " done. (" ...
         + num2str(t_R + t_A1 + t_A2 + t_D + t_M) + " s)");
    
end

