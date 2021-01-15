%% SO_Results.m - Frédéric Berdoz - November 2020 
%
% Secondary runabale script for the Sobol analysis applied to the ERT
% simulator. Plots and analyse the results obtained by Main_SO.m
% 

close all;

% Figure style
fs = 12;
lab_rot = 90;
geom = [0, 0, 800, 7/12 * 800];
lab_rot = 90;
colors = ["#0072BD" "#D95319" "#EDB120"	"#7E2F8E" "#77AC30"	"#4DBEEE" "#A2142F"];
SAVE = false;

%% Load
filename = "SO_k53_o13_N4096_Sobol";
load("Outputs/" + filename);
mkdir("Figures/" + filename);

%% Results
% Mean and variance
f_0 = mean(Y_X,2);
V = mean(Y_X.^2, 2) - f_0.^2;

if ~ONLYDLR
    % Sobol
    U_is = NaN(o, k);
    U_nis = NaN(o, k);

    for i = 1:k
        U_is(:,i) = mean(Y_X .* Y_is(:,:,i), 2) - f_0.^2;
        U_nis(:,i) = mean(Y_X .* Y_nis(:,:,i), 2) - f_0.^2;
    end
    S_is = U_is./V;
    S_Tis = ones(o,1) - U_nis./V;
    
    % Kucherencko
    UK_is = NaN(o, k);
    UK_nis = NaN(o, k);

    for i = 1:k
        UK_is(:,i) = mean(Y_X .* (Y_is(:,:,i) - Y_Z), 2);
        UK_nis(:,i) = mean(Y_X .* (Y_nis(:,:,i) - Y_Z), 2);
    end
    SK_is = UK_is./V;
    SK_Tis = ones(o,1) - UK_nis./V;


    % Myshetzskay
    UM_is = NaN(o, k);
    UM_nis = NaN(o, k);

    for i = 1:k
        UM_is(:,i) = mean((Y_X - f_0) .* (Y_is(:,:,i) - Y_Z), 2);
        UM_nis(:,i) = mean((Y_X - f_0) .* (Y_nis(:,:,i) - Y_Z), 2);
    end
    SM_is = UM_is./V;
    SM_Tis = ones(o,1) - UM_nis./V;
end

% Double loop reordering (no total sobol indices)
M = sqrt(N);
UDLR_is = NaN(o,k);
std_bins = NaN(o,M,k);
E_bins = NaN(o,M,k);
for i = 1:k
    [X_sorted_i, idx] = sortrows(X',i);
    X_sorted_i = X_sorted_i';
    Y_X_sorted = Y_X(:, idx);
    for j = 1:M
        idx_bin = ((j-1)*M + 1):j*M;
        E_bins(:,j,i) = mean(Y_X_sorted(:,idx_bin), 2);
        std_bins(:,j,i) = std(Y_X_sorted(:,idx_bin), 1, 2);
    end
    UDLR_is(:,i) = mean(E_bins(:,:,i).^2, 2) - f_0.^2;
end
SDLR_is = UDLR_is./V;

%% Error calculation
LHC = load("Outputs/SO_k53_o13_N4096_LHC");
%% Convergence Analysis
if ~ONLYDLR
    
    S_is_n = NaN(o, k, N);
    S_Tis_n = NaN(o, k, N);

    for n = 1:N
        U_is_n = NaN(o, k);
        U_nis_n = NaN(o, k);

        for i = 1:k
            U_is_n(:,i) = mean(Y_X(:,1:n).* Y_is(:,(1:n),i), 2);
            U_nis_n(:,i) = mean(Y_X.* Y_nis(:,:,i), 2);
        end

        % Mean and variance
        f_0_n = (1/2) * (mean(Y_X(:,1:n),2) + mean(Y_Z(:,1:n), 2));
        V_n = 1/2 * (mean(Y_X(:,1:n).^2, 2) + mean(Y_Z(:,1:n).^2, 2)) - f_0_n.^2;

        C = mean(Y_X(:,1:n).*Y_Z(:,1:n), 2) - f_0_n.^2;

        S_is_n(:,:,n) = (U_is_n - f_0_n.^2)./V_n;
        S_Tis_n(:,:,n) = ones(o,1) - (U_nis_n - f_0_n.^2)./V_n;
    end

    for j = 1:o
        yid = Yid(j);
        figure("Name", "Sobol Analysis: " + yid, 'Units', 'pixels', 'Position', geom);
        subplot(2,1,1)
        title("1st Order Sobol Indices: " + yid, 'Interpreter', 'none');
        hold on; grid on;
        set(gca,'FontSize', fs, 'ylim', [-100, 100], 'DefaultTextInterpreter', 'none');
        ylabel("S_i");
        
        if SAVE
            savefig("Figures/" + filename + "/" + yid + ".fig");
        end
   
        for i = 1:k
            plot(1:N, squeeze(S_is_n(j,i,:)), '-o', 'Color', colors(i), 'DisplayName', Xid(i))
        end
        legend show

        subplot(2,1,2)
        title("Total Sobol Indices: " + yid, 'Interpreter', 'none');
        hold on; grid on;
        set(gca,'FontSize', fs, 'ylim', [-100, 100], 'DefaultTextInterpreter', 'none');
        ylabel("S_Ti");
        
        if SAVE
            savefig("Figures/" + filename + "/" + yid + ".fig");
        end
        
        for i = 1:k
            plot(1:N, squeeze(S_Tis_n(j,i,:)), '-o', 'Color', colors(i), 'DisplayName', Xid(i))
        end
        legend show
        hold off;
    end
end

%% DLR
close all;
Y_to_plt = ["apogee" "MarCNa_av" "landing_drift"];

% Inputs categories
Xid_env = ["Temperature_Ground" "Pressure_Ground" "Humidity_Ground" "Start_Altitude" "dTdh" "Vi1" "Vi2" "Vi3" "Vi4" "Vi5" "Vi6" "ai1" "ai2" "ai3" "ai4" "ai5" "ai6"];

Xid_rail = ["Rail_Length" "Rail_Angle" "Rail_Azimuth"];
    
Xid_roc = [ "dmin" "dd" "z1" "z12" "z23" "fin_xt" "fin_s" "fin_cr" "fin_ct" "fin_xs" ...
        "fin_t" "lug_S" "rocket_m" "rocket_I" "rocket_cm" "ab_x" "ab_phi" ... 
        "pl_mass" "para_main_SCD" "para_drogue_SCD" "para_main_event" "intermotor_d" "motor_diaP" ...
        "motor_lengthP" "propel_massP" "motor_massP" "motor_diaF" "motor_lengthF" "propel_massF" ...
        "motor_massF" "Burn_Time" "T1" "T2"];

for i = 1:o
    yid = Yid(i);
    figure("Name", "Sobol Analysis (DLR): " + yid, 'Units', 'pixels', 'Position', geom);
    title("1st Order Sobol Indices: " + yid, 'Interpreter', 'none');
    hold on;
    grid on;
    
    [S_sorted, idx_sorted] = sort(SDLR_is(i,:), 2);
    Xid_sorted =Xid(idx_sorted);
    
    
    S_sorted = S_sorted/sum(S_sorted);
    cat = categorical(Xid(idx_sorted));
    cat = reordercats(cat, Xid(idx_sorted));
    
    b = bar(cat, S_sorted, 0.6);
    
    S_sorted_LHC = LHC.SDLR_is(i,idx_sorted);
    b_LHC = bar(cat, S_sorted_LHC/sum(S_sorted_LHC), 0.15, 'FaceColor', 'black');
    
    
    % Colors
    b.FaceColor = 'Flat';
    if yid == "MarCNa_av"
        ylim([0 0.15]);
    end
    
    
    for j = 1:k
        if ismember(Xid_sorted(j), Xid_env)
            b.CData(j,:) = [0.4660 0.6740 0.1880];
        elseif ismember(Xid_sorted(j), Xid_rail)
            b.CData(j,:) = [0 0.4470 0.7410];
        elseif ismember(Xid_sorted(j), Xid_roc)
            b.CData(j,:) = [0.8500 0.3250 0.0980];   
        end
    end
    
    ax = gca;
    ax.TickLabelInterpreter = 'none';
    ylabel("S [-]");
    
    if SAVE
        saveas(gcf, "Figures/" + filename + "/" + yid + "_DLR.eps", 'epsc');
    end
    hold off;
end
