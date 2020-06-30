% Initialize
close all; clear all;
warning off;
addpath(genpath('../Declarations'),...
        genpath('../Functions'),...
        genpath('../Snippets'),...
        genpath('../Simulator_1D'));

% boolean1 == 0 -> rocket natural selection, else interpolation
boolean1 = 0;


n_sim = 24;
Rocket_0 = rocketReader('BL_H4.txt');
SimOutputs = SimOutputReader('Simulation/Simulation_outputs.txt');
azimuth_i = 0:11.25:348.75;
azi =  ones(1,32)*0;
if boolean1 == 1 
    j=0;
    for b = azimuth_i
        j = j +1;
        [c,~,~, ~, ~, ~] = landing_tool(n_sim,-1, b/180*pi, Rocket_0, SimOutputs); 
        azi(j) = azi(j) + c;
    end
    Vazy = interp1(azimuth_i,azi,azimuth_i, 'pchip', 'extrap');
    hold on
    plot(azimuth_i,Vazy,'r')
    xlim([0 360])
    ylim([-1 50000])
    hold off;    
else
    nb_round = 0;
    while (length(azi) > 1)
        j=0;
        nb_round =nb_round+ 1;
        for b = azimuth_i
            j = j +1;
            [c,~,~, ~, ~, ~] = landing_tool(n_sim,-1, b/180*pi, Rocket_0, SimOutputs); 
            azi(j) = azi(j) + c;
        end
        mean1 = mean(azi);
        xdc = azi<mean1;
        azi = azi(xdc);
        azimuth_i = azimuth_i(xdc);
        display(['mean area for 95% interval is : ' num2str(mean1)]);
        display(['Best 50% rail angles are : ' num2str(azimuth_i)]);
        display(['Best 50% values are : ' num2str(azi)]);
    end


[min_area,r_ellipse,r_ellipse1, X0, Y0, data] = landing_tool(n_sim,-1,azimuth_i/180*pi, Rocket_0, SimOutputs);

Environment = environnementReader('Environment/Environnement_Definition_Meringen.txt',1);
Environment = setfield(Environment, 'Rail_Azimuth', azimuth_i/180*pi);

SimObj = multilayerwindSimulator3D(Rocket_0, Environment, SimOutputs);
[T1, S1] = SimObj.RailSim();
[T2_1, S2_1, T2_1E, S2_1E, I2_1E] = SimObj.FlightSim([T1(end) SimObj.Rocket.Burn_Time(end)], S1(end, 2));
[T2_2, S2_2, T2_2E, S2_2E, I2_2E] = SimObj.FlightSim([T2_1(end) 40], S2_1(end, 1:3)', S2_1(end, 4:6)', S2_1(end, 7:10)', S2_1(end, 11:13)');
T2 = [T2_1; T2_2(2:end)];
S2 = [S2_1; S2_2(2:end, :)];
T_1_2 = [T1;T2];
S_1_2 = [S1;S2(:,3) S2(:,6)];
[T3, S3, T3E, S3E, I3E] = SimObj.DrogueParaSim(T2(end), S2(end,1:3)', S2(end, 4:6)');
[T4, S4, T4E, S4E, I4E] = SimObj.MainParaSim(T3(end), S3(end,1:3)', S3(end, 4:6)');

%plot rocket orientation
figure('Name','montecarlo'); hold on;
%plot trajectory of CM
zoom = 15;
[XX, YY, M, Mcolor] = get_google_map(Environment.Start_Latitude, Environment.Start_Longitude, 'Height', 640, 'Width', 640, 'Zoom', zoom);
metersPerPx = 156543.03392 * cos(Environment.Start_Latitude*pi/180)/ 2^zoom;
lim = metersPerPx*640/2; % because [-lim + lim ] = 2 lim
xlim = [-lim lim];
ylim = [-lim lim];
xImage = [xlim',xlim'];
yImage = [ylim;ylim];
zImage = zeros(2);
colormap(Mcolor);
surf(xImage, yImage, zImage, 'CData', M,'FaceColor', 'texturemap', 'EdgeColor', 'none', 'DisplayName', 'Base Map');
plot3(S2(:,1), S2(:,2), S2(:,3), 'DisplayName', 'Ascent','LineWidth',1);
plot3(S3(:,1), S3(:,2), S3(:,3), 'DisplayName', 'Drogue Descent','LineWidth',1);
plot3(S4(:,1), S4(:,2), S4(:,3), 'DisplayName', 'Main Descent','LineWidth',1);
plot3(r_ellipse(:,1) + X0,r_ellipse(:,2) + Y0,0*r_ellipse(:,2),'DisplayName', '95% confidence Interval','LineWidth',1);
plot3(r_ellipse1(:,1) + X0,r_ellipse1(:,2) + Y0,0*r_ellipse1(:,2),'DisplayName', '99,99% confidence Interval','LineWidth',1);
plot3(data(:,1), data(:,2),0*data(:,2),'*k' , 'DisplayName', 'noised landing');
daspect([1 1 1]); pbaspect([1, 1, 2]); view(45, 45);
title '3D trajectory representation'
xlabel 'S [m]'; ylabel 'E [m]'; zlabel 'Altitude [m]';
legend show;
display(['Optimal rail azimuth is : ' num2str(azimuth_i)]);
display(['min area in square meter for 95% interval is : ' num2str((min_area+azi)/(nb_round+1))]);
end
