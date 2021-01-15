%% EE_Results.m - Frédéric Berdoz - November 2020 
%
% Secondary runabale script for the numerical stability analysis. Plots and analyse the results obtained by Main_NS.m
% 

close all; clear all;

% Control
ifPlot = false;
ifSave = true;
% Figure style
fs = 14;
ls = 1.2;
ms = 7;
geom = [0, 0, 1200, 6/12 * 1200];
lab_rot = 90;
colors = ["#0072BD" "#D95319" "#EDB120"	"#7E2F8E" "#77AC30"	"#4DBEEE" "#A2142F"];	




%% Load
filename = "NS_N50";
load("Outputs/" + filename);
mkdir("Figures/" + filename);

%% Plot runtime
if ifPlot %on/off
    figure("Name", "Numerical Stability Analysis: Runtime", 'Units', 'pixels', 'Position', geom);
    title("Runtime of the Simulations", 'Interpreter', 'none');
    hold on; grid on;
    set(gca, 'FontSize', fs, 'Xlim', [0 N+1]);
    ylabel("Runtime [s]");
    xlabel("Suimulation Id");
        
    
    plot(1:N, sum(t_45,1), 'd', 'MarkerSize', ms, 'MarkerFaceColor', colors(1), 'LineWidth', ls);
    plot(1:N, sum(t_23,1), 'x', 'MarkerSize', ms, 'MarkerFaceColor', colors(2), 'LineWidth', ls);
    plot(1:N, sum(t_113,1), '+', 'MarkerSize', ms, 'MarkerFaceColor', colors(3), 'LineWidth', ls);
    plot(1:N, sum(t_15s,1), '*', 'MarkerSize', ms, 'MarkerFaceColor', colors(4), 'LineWidth', ls);
    plot(1:N, sum(t_23s,1), '^', 'MarkerSize', ms, 'MarkerFaceColor', colors(5), 'LineWidth', ls);
    plot(1:N, sum(t_23t,1), 'v', 'MarkerSize', ms, 'MarkerFaceColor', colors(6), 'LineWidth', ls);
    plot(1:N, sum(t_23tb,1), 'p', 'MarkerSize', ms, 'MarkerFaceColor', colors(7), 'LineWidth', ls);
   
    
    plot(0:N+1, ones(1, N+2) * mean(sum(t_45,1), 2), '-', 'Color', colors(1), 'LineWidth', ls);
    plot(0:N+1, ones(1, N+2) * mean(sum(t_23,1), 2), '-', 'Color', colors(2), 'LineWidth', ls);
    plot(0:N+1, ones(1, N+2) * mean(sum(t_113,1), 2), '-', 'Color', colors(3), 'LineWidth', ls);
    plot(0:N+1, ones(1, N+2) * mean(sum(t_15s,1), 2), '-', 'Color', colors(4), 'LineWidth', ls);
    plot(0:N+1, ones(1, N+2) * mean(sum(t_23s,1), 2), '-', 'Color', colors(5), 'LineWidth', ls);
    plot(0:N+1, ones(1, N+2) * mean(sum(t_23t,1), 2), '-', 'Color', colors(6), 'LineWidth', ls);
    plot(0:N+1, ones(1, N+2) * mean(sum(t_23tb,1), 2), '-', 'Color', colors(7), 'LineWidth', ls);
    
    
    legend('ode45', 'ode23', 'ode113', 'ode15s', 'ode23s', 'ode23t', 'ode23tb');
    if ifSave
        saveas(gcf, "Figures/" + filename + "/runtime.eps", 'epsc');
    end
end

%% Runtime of each phase
clc;

%ode45
t_45_pc = t_45./sum(t_45, 1)*100;
m_45 = mean(t_45_pc,2);
std_45 = std(t_45_pc, 1, 2);
disp("ode45:")
disp("  Fraction of time spend on R:  " + num2str(m_45(1), '%.1f') + " & " + num2str(std_45(1), '%.1f'));
disp("  Fraction of time spend on A1: " + num2str(m_45(2), '%.1f') + " & " + num2str(std_45(2), '%.1f'));
disp("  Fraction of time spend on A2: " + num2str(m_45(3), '%.1f') + " & " + num2str(std_45(3), '%.1f'));
disp("  Fraction of time spend on D:  " + num2str(m_45(4), '%.1f') + " & " + num2str(std_45(4), '%.1f'));
disp("  Fraction of time spend on M:  " + num2str(m_45(5), '%.1f') + " & " + num2str(std_45(5), '%.1f'));
disp("                    Total [s]:  " + num2str(mean(sum(t_45, 1)), '%.1f') + " & " + num2str(std(sum(t_45, 1)), '%.1f'));
%ode23
t_23_pc = t_23./sum(t_23, 1)*100;
m_23 = mean(t_23_pc,2);
std_23 = std(t_23_pc, 1, 2);
disp("ode23:")
disp("  Fraction of time spend on R:  " + num2str(m_23(1), '%.1f') + " & " + num2str(std_23(1), '%.1f'));
disp("  Fraction of time spend on A1: " + num2str(m_23(2), '%.1f') + " & " + num2str(std_23(2), '%.1f'));
disp("  Fraction of time spend on A2: " + num2str(m_23(3), '%.1f') + " & " + num2str(std_23(3), '%.1f'));
disp("  Fraction of time spend on D:  " + num2str(m_23(4), '%.1f') + " & " + num2str(std_23(4), '%.1f'));
disp("  Fraction of time spend on M:  " + num2str(m_23(5), '%.1f') + " & " + num2str(std_23(5), '%.1f'));
disp("                    Total [s]:  " + num2str(mean(sum(t_23, 1)), '%.1f') + " & " + num2str(std(sum(t_23, 1)), '%.1f'));

%ode113
t_113_pc = t_113./sum(t_113, 1)*100;
m_113 = mean(t_113_pc,2);
std_113 = std(t_113_pc, 1, 2);
disp("ode113:")
disp("  Fraction of time spend on R:  " + num2str(m_113(1), '%.1f') + " & " + num2str(std_113(1), '%.1f'));
disp("  Fraction of time spend on A1: " + num2str(m_113(2), '%.1f') + " & " + num2str(std_113(2), '%.1f'));
disp("  Fraction of time spend on A2: " + num2str(m_113(3), '%.1f') + " & " + num2str(std_113(3), '%.1f'));
disp("  Fraction of time spend on D:  " + num2str(m_113(4), '%.1f') + " & " + num2str(std_113(4), '%.1f'));
disp("  Fraction of time spend on M:  " + num2str(m_113(5), '%.1f') + " & " + num2str(std_113(5), '%.1f'));
disp("                    Total [s]:  " + num2str(mean(sum(t_113, 1)), '%.1f') + " & " + num2str(std(sum(t_113, 1)), '%.1f'));

%ode15s
t_15s_pc = t_15s./sum(t_15s, 1)*100;
m_15s = mean(t_15s_pc,2);
std_15s = std(t_15s_pc, 1, 2);
disp("ode15s:")
disp("  Fraction of time spend on R:  " + num2str(m_15s(1), '%.1f') + " & " + num2str(std_15s(1), '%.1f'));
disp("  Fraction of time spend on A1: " + num2str(m_15s(2), '%.1f') + " & " + num2str(std_15s(2), '%.1f'));
disp("  Fraction of time spend on A2: " + num2str(m_15s(3), '%.1f') + " & " + num2str(std_15s(3), '%.1f'));
disp("  Fraction of time spend on D:  " + num2str(m_15s(4), '%.1f') + " & " + num2str(std_15s(4), '%.1f'));
disp("  Fraction of time spend on M:  " + num2str(m_15s(5), '%.1f') + " & " + num2str(std_15s(5), '%.1f'));
disp("                    Total [s]:  " + num2str(mean(sum(t_15s, 1)), '%.1f') + " & " + num2str(std(sum(t_15s, 1)), '%.1f'));

%ode23s
t_23s_pc = t_23s./sum(t_23s, 1)*100;
m_23s = mean(t_23s_pc,2);
std_23s = std(t_23s_pc, 1, 2);
disp("ode23s:")
disp("  Fraction of time spend on R:  " + num2str(m_23s(1), '%.1f') + " & " + num2str(std_23s(1), '%.1f'));
disp("  Fraction of time spend on A1: " + num2str(m_23s(2), '%.1f') + " & " + num2str(std_23s(2), '%.1f'));
disp("  Fraction of time spend on A2: " + num2str(m_23s(3), '%.1f') + " & " + num2str(std_23s(3), '%.1f'));
disp("  Fraction of time spend on D:  " + num2str(m_23s(4), '%.1f') + " & " + num2str(std_23s(4), '%.1f'));
disp("  Fraction of time spend on M:  " + num2str(m_23s(5), '%.1f') + " & " + num2str(std_23s(5), '%.1f'));
disp("                    Total [s]:  " + num2str(mean(sum(t_23s, 1)), '%.1f') + " & " + num2str(std(sum(t_23s, 1)), '%.1f'));

%ode23t
t_23t_pc = t_23t./sum(t_23t, 1)*100;
m_23t = mean(t_23t_pc,2);
std_23t = std(t_23t_pc, 1, 2);
disp("ode23t:")
disp("  Fraction of time spend on R:  " + num2str(m_23t(1), '%.1f') + " & " + num2str(std_23t(1), '%.1f'));
disp("  Fraction of time spend on A1: " + num2str(m_23t(2), '%.1f') + " & " + num2str(std_23t(2), '%.1f'));
disp("  Fraction of time spend on A2: " + num2str(m_23t(3), '%.1f') + " & " + num2str(std_23t(3), '%.1f'));
disp("  Fraction of time spend on D:  " + num2str(m_23t(4), '%.1f') + " & " + num2str(std_23t(4), '%.1f'));
disp("  Fraction of time spend on M:  " + num2str(m_23t(5), '%.1f') + " & " + num2str(std_23t(5), '%.1f'));
disp("                    Total [s]:  " + num2str(mean(sum(t_23t, 1)), '%.1f') + " & " + num2str(std(sum(t_23t, 1)), '%.1f'));

%ode23tb
t_23tb_pc = t_23tb./sum(t_23tb, 1)*100;
m_23tb = mean(t_23tb_pc,2);
std_23tb = std(t_23tb_pc, 1, 2);
disp("ode23tb:")
disp("  Fraction of time spend on R:  " + num2str(m_23tb(1), '%.1f') + " & " + num2str(std_23tb(1), '%.1f'));
disp("  Fraction of time spend on A1: " + num2str(m_23tb(2), '%.1f') + " & " + num2str(std_23tb(2), '%.1f'));
disp("  Fraction of time spend on A2: " + num2str(m_23tb(3), '%.1f') + " & " + num2str(std_23tb(3), '%.1f'));
disp("  Fraction of time spend on D:  " + num2str(m_23tb(4), '%.1f') + " & " + num2str(std_23tb(4), '%.1f'));
disp("  Fraction of time spend on M:  " + num2str(m_23tb(5), '%.1f') + " & " + num2str(std_23tb(5), '%.1f'));
disp("                    Total [s]:  " + num2str(mean(sum(t_23tb, 1)), '%.1f') + " & " + num2str(std(sum(t_23tb, 1)), '%.1f'));

%% Display accuracy

d45_23 = sqrt(sum((Y_45 - Y_23).^2, 2));
d45_113 = sqrt(sum((Y_45 - Y_113).^2, 2));
d45_15s = sqrt(sum((Y_45 - Y_15s).^2, 2));
d45_23s = sqrt(sum((Y_45 - Y_23s).^2, 2));
d45_23t = sqrt(sum((Y_45 - Y_23t).^2, 2));
d45_23tb = sqrt(sum((Y_45 - Y_23tb).^2, 2));

d23_113 = sqrt(sum((Y_23 - Y_113).^2, 2));
d23_15s = sqrt(sum((Y_23 - Y_15s).^2, 2));
d23_23s = sqrt(sum((Y_23 - Y_23s).^2, 2));
d23_23t = sqrt(sum((Y_23 - Y_23t).^2, 2));
d23_23tb = sqrt(sum((Y_23 - Y_23tb).^2, 2));

d113_15s = sqrt(sum((Y_113 - Y_15s).^2, 2));
d113_23s = sqrt(sum((Y_113 - Y_23s).^2, 2));
d113_23t = sqrt(sum((Y_113 - Y_23t).^2, 2));
d113_23tb = sqrt(sum((Y_113 - Y_23tb).^2, 2));

d15s_23s = sqrt(sum((Y_15s - Y_23s).^2, 2));
d15s_23t = sqrt(sum((Y_15s - Y_23t).^2, 2));
d15s_23tb = sqrt(sum((Y_15s - Y_23tb).^2, 2));

d23s_23t = sqrt(sum((Y_23s - Y_23t).^2, 2));
d23s_23tb = sqrt(sum((Y_23s - Y_23tb).^2, 2));

d23t_23tb = sqrt(sum((Y_23t - Y_23tb).^2, 2));

d45_av = (1/6)*(d45_23 + d45_113 + d45_15s + d45_23s + d45_23t + d45_23tb);
d23_av = (1/6)*(d45_23 + d23_113 + d23_15s + d23_23s + d23_23t + d23_23tb);
d113_av = (1/6)*(d45_113 + d23_113 + d113_15s + d113_23s + d113_23t + d113_23tb);
d15s_av = (1/6)*(d45_15s + d23_15s + d113_15s + d15s_23s + d15s_23t + d15s_23tb);
d23s_av = (1/6)*(d45_23s + d23_23s + d113_23s + d15s_23s + d23s_23t + d23s_23tb);
d23t_av = (1/6)*(d45_23t + d23_23t + d113_23t + d15s_23t + d23s_23t + d23t_23tb);
d23tb_av = (1/6)*(d45_23tb + d23_23tb + d113_23tb + d15s_23tb + d23s_23tb + d23t_23tb);

disp("ode45: ")
disp("   Apogee:" + num2str(mean(d45_av(1,:)), '%.2f') + " & " + num2str(std(d45_av(1,:)), '%.2f'));
disp("  Landing:" + num2str(mean(d45_av(2,:)), '%.2f') + " & " + num2str(std(d45_av(2,:)), '%.2f'));

disp("ode23: ")
disp("   Apogee:" + num2str(mean(d23_av(1,:)), '%.2f') + " & " + num2str(std(d23_av(1,:)), '%.2f'));
disp("  Landing:" + num2str(mean(d23_av(2,:)), '%.2f') + " & " + num2str(std(d23_av(2,:)), '%.2f'));

disp("ode113: ")
disp("   Apogee:" + num2str(mean(d113_av(1,:)), '%.2f') + " & " + num2str(std(d113_av(1,:)), '%.2f'));
disp("  Landing:" + num2str(mean(d113_av(2,:)), '%.2f') + " & " + num2str(std(d113_av(2,:)), '%.2f'));

disp("ode15s: ")
disp("   Apogee:" + num2str(mean(d15s_av(1,:)), '%.2f') + " & " + num2str(std(d15s_av(1,:)), '%.2f'));
disp("  Landing:" + num2str(mean(d15s_av(2,:)), '%.2f') + " & " + num2str(std(d15s_av(2,:)), '%.2f'));

disp("ode23s: ")
disp("   Apogee:" + num2str(mean(d23s_av(1,:)), '%.2f') + " & " + num2str(std(d23s_av(1,:)), '%.2f'));
disp("  Landing:" + num2str(mean(d23s_av(2,:)), '%.2f') + " & " + num2str(std(d23s_av(2,:)), '%.2f'));

disp("ode23t: ")
disp("   Apogee:" + num2str(mean(d23t_av(1,:)), '%.2f') + " & " + num2str(std(d23t_av(1,:)), '%.2f'));
disp("  Landing:" + num2str(mean(d23t_av(2,:)), '%.2f') + " & " + num2str(std(d23t_av(2,:)), '%.2f'));

disp("ode23tb: ")
disp("   Apogee:" + num2str(mean(d23tb_av(1,:)), '%.2f') + " & " + num2str(std(d23tb_av(1,:)), '%.2f'));
disp("  Landing:" + num2str(mean(d23tb_av(2,:)), '%.2f') + " & " + num2str(std(d23tb_av(2,:)), '%.2f'));
%% Plot accuracy
if ifPlot %on/off
    
    figure("Name", "Numerical Stability Analysis: Accuracy", 'Units', 'pixels', 'Position', geom);
    % Apogee
    subplot(2,1,1);
    title("Distance at Apogee", 'Interpreter', 'none');
    hold on; grid on;
    set(gca, 'FontSize', fs, 'Xlim', [0 N+1]);
    ylabel("Distance [m]");
    xlabel("Suimulation Id");

    
    plot(1:N, d45_av(1,:), 'd', 'MarkerSize', ms, 'MarkerFaceColor', colors(1), 'LineWidth', ls, 'DisplayName', 'ode45');
    plot(1:N, d23_av(1,:), 'x', 'MarkerSize', ms, 'MarkerFaceColor', colors(2), 'LineWidth', ls, 'DisplayName', 'ode23');
    plot(1:N, d113_av(1,:), '+', 'MarkerSize', ms, 'MarkerFaceColor', colors(3), 'LineWidth', ls, 'DisplayName', 'ode113');
    plot(1:N, d15s_av(1,:), '*', 'MarkerSize', ms, 'MarkerFaceColor', colors(4), 'LineWidth', ls, 'DisplayName', 'ode15s');
    plot(1:N, d23s_av(1,:), '^', 'MarkerSize', ms, 'MarkerFaceColor', colors(5), 'LineWidth', ls, 'DisplayName', 'ode23s');
    plot(1:N, d23t_av(1,:), 'v', 'MarkerSize', ms, 'MarkerFaceColor', colors(6), 'LineWidth', ls, 'DisplayName', 'ode23t');
    plot(1:N, d23tb_av(1,:), 'p', 'MarkerSize', ms, 'MarkerFaceColor', colors(7), 'LineWidth', ls, 'DisplayName', 'ode23tb');
    
    plot(0:N+1, ones(1, N+2) * mean(d45_av(1,:)), '-', 'Color', colors(1), 'LineWidth', ls, 'DisplayName', 'ode45');
    plot(0:N+1, ones(1, N+2) * mean(d23_av(1,:)), '-',  'Color', colors(2), 'LineWidth', ls, 'DisplayName', 'ode23');
    plot(0:N+1, ones(1, N+2) * mean(d113_av(1,:)), '-', 'Color', colors(3), 'LineWidth', ls, 'DisplayName', 'ode113');
    plot(0:N+1, ones(1, N+2) * mean(d15s_av(1,:)), '-', 'Color', colors(4), 'LineWidth', ls, 'DisplayName', 'ode15s');
    plot(0:N+1, ones(1, N+2) * mean(d23s_av(1,:)), '-', 'Color', colors(5), 'LineWidth', ls, 'DisplayName', 'ode23s');
    plot(0:N+1, ones(1, N+2) * mean(d23t_av(1,:)), '-', 'Color', colors(6), 'LineWidth', ls, 'DisplayName', 'ode23t');
    plot(0:N+1, ones(1, N+2) * mean(d23tb_av(1,:)), '-', 'Color', colors(7), 'LineWidth', ls, 'DisplayName', 'ode23tb');
    
    legend('ode45', 'ode23', 'ode113', 'ode15s', 'ode23s', 'ode23t', 'ode23tb');
    
    
   
    % Landing
    subplot(2,1,2);
    title("Distance at Landing", 'Interpreter', 'none');
    hold on; grid on;
    set(gca, 'FontSize', fs, 'Xlim', [0 N+1]);
    ylabel("Distance [m]");
    xlabel("Suimulation Id");
 
    plot(1:N, d45_av(2,:), 'd', 'MarkerSize', ms, 'MarkerFaceColor', colors(1), 'LineWidth', ls, 'DisplayName', 'ode45');
    plot(1:N, d23_av(2,:), 'x', 'MarkerSize', ms, 'MarkerFaceColor', colors(2), 'LineWidth', ls, 'DisplayName', 'ode23');
    plot(1:N, d113_av(2,:), '+', 'MarkerSize', ms, 'MarkerFaceColor', colors(3), 'LineWidth', ls, 'DisplayName', 'ode113');
    plot(1:N, d15s_av(2,:), '*', 'MarkerSize', ms, 'MarkerFaceColor', colors(4), 'LineWidth', ls, 'DisplayName', 'ode15s');
    plot(1:N, d23s_av(2,:), '^', 'MarkerSize', ms, 'MarkerFaceColor', colors(5), 'LineWidth', ls, 'DisplayName', 'ode23s');
    plot(1:N, d23t_av(2,:), 'v', 'MarkerSize', ms, 'MarkerFaceColor', colors(6), 'LineWidth', ls, 'DisplayName', 'ode23t');
    plot(1:N, d23tb_av(2,:), 'p', 'MarkerSize', ms, 'MarkerFaceColor', colors(7), 'LineWidth', ls, 'DisplayName', 'ode23tb');
    
    plot(0:N+1, ones(1, N+2) * mean(d45_av(2,:)), '-', 'Color', colors(1), 'LineWidth', ls, 'DisplayName', 'ode45');
    plot(0:N+1, ones(1, N+2) * mean(d23_av(2,:)), '-',  'Color', colors(2), 'LineWidth', ls, 'DisplayName', 'ode23');
    plot(0:N+1, ones(1, N+2) * mean(d113_av(2,:)), '-', 'Color', colors(3), 'LineWidth', ls, 'DisplayName', 'ode113');
    plot(0:N+1, ones(1, N+2) * mean(d15s_av(2,:)), '-', 'Color', colors(4), 'LineWidth', ls, 'DisplayName', 'ode15s');
    plot(0:N+1, ones(1, N+2) * mean(d23s_av(2,:)), '-', 'Color', colors(5), 'LineWidth', ls, 'DisplayName', 'ode23s');
    plot(0:N+1, ones(1, N+2) * mean(d23t_av(2,:)), '-', 'Color', colors(6), 'LineWidth', ls, 'DisplayName', 'ode23t');
    plot(0:N+1, ones(1, N+2) * mean(d23tb_av(2,:)), '-', 'Color', colors(7), 'LineWidth', ls, 'DisplayName', 'ode23tb');
    
    legend('ode45', 'ode23', 'ode113', 'ode15s', 'ode23s', 'ode23t', 'ode23tb');
    if ifSave
        saveas(gcf, "Figures/" + filename + "/d_av.eps", 'epsc');
    end
end



