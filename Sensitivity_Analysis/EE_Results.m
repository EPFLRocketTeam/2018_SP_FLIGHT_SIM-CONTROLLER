%% EE_Results.m - Frédéric Berdoz - November 2020 
%
% Secondary runabale script for the elementary Effect method (Morris, 1993) applied to the ERT
% simulator. Plots and analyse the results obtained by Main_EE.m
% 

close all;

% Figure style
fs = 12;
geom = [0, 0, 800, 6/12 * 800];
lab_rot = 90;
isAbs = false;
SAVE = false;

%% Load
filename = "EE_k53_o13_r50";
load("Outputs/" + filename);
mkdir("Figures/" + filename);

%% Plot (mu)
if false %on/off
    for j = 1:o
        yid = Yid(j);
        Xid_sorted = Xid(idx_sorted(:,j));
        figure("Name", "Elementary Analysis: " + yid, 'Units', 'pixels', 'Position', geom);
        title("Elementary Analysis: " + yid, 'Interpreter', 'none');
        hold on; grid on;
        plot(1:k, mu_sorted(:,j), 'bd', 'MarkerSize', 6, 'MarkerFaceColor', 'none', 'LineWidth', 0.7);
        set(gca,'XTickLabelRotation', lab_rot, ...
                'DefaultTextInterpreter', 'none', ...
                'FontSize', fs, ...
                'xtick', 1:k, ...
                'xticklabel', Xid_sorted, ...
                'TickLabelInterpreter','none',...
                'xlim', [0 k+1], 'Position', [0.075 0.3 0.9 0.65]);
        ylabel("Elemetary Effect: " + yid);
        
        if SAVE
            saveas(gcf, "Figures/" + filename + "/" + yid + ".eps", 'epsc');
        end
    end
end

%% Boxplot

if true %on/off
    for j = 1:o
        yid = Yid(j);
        Xid_sorted = Xid(idx_sorted(:,j));
        figure("Name", "Elementary Analysis: " + yid, 'Units', 'pixels', 'Position', geom);
        if isAbs
            boxplot(abs(d(:,idx_sorted(:,j),j)));
        else
            boxplot(d(:,idx_sorted(:,j),j));
        end
        hold on; grid on;
        title("Elementary Analysis (boxplot): " + yid, 'Interpreter', 'none');
        set(gca,'XTickLabelRotation', lab_rot, ...
                'DefaultTextInterpreter', 'none', ...
                'FontSize', fs, ...
                'xtick', 1:k, ...
                'xticklabel', Xid_sorted, ...
                'TickLabelInterpreter','none', ...
                'xlim', [0 k+1], 'Position', [0.075 0.3 0.9 0.65]);
        set(gca, 'YScale', 'log');   
        ylabel("Elemetary Effect: " + yid);
        
        if SAVE
            saveas(gcf, "Figures/" + filename + "/" + yid + "_BP.eps", 'epsc');
        end
    end
end
