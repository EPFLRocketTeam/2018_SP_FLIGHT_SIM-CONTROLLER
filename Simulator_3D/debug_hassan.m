Rocket_maxHeight = S2(end,3)


%%
nominalTrag= [T2, S2(:,1:3)];
save('nominalTrag','nominalTrag')
%%
x =T2;
y=S2(:,3);
e = 160/3.1883e+03*y;
lo = y - e;
hi = y + e;

hp = patch([x; x(end:-1:1); x(1)], [lo; hi(end:-1:1); lo(1)], 'r');
hold on;
hl = line(x,y);

set(hp, 'facecolor', [1 0.8 0.8], 'edgecolor', 'none');
set(hl, 'color', 'r');
%boundedline(T2,S2(:,3),T2)
xlabel('Time (s)')
ylabel('Height (m)')
title('Variance in apogee due to parameter uncertainty')

%%
load('nominalTrag')
hold on 
plot(nominalTrag(:,1), nominalTrag(:,4),'r','LineWidth',2 )
title 'Effect of variance in center of pressure on Altitude'
%%
title 'Variance in apogee due to parameter uncertainty, Std = 160[m]'
xlabel 't [s]'; ylabel 'Altitude [m]';

%%
% Wind Model
V_inf = 3;
for h=1:3000
  h_alt = h;
  z0 = 0.0024; % [m]; % terrain roughness length [m] (desert)
  h_ground = 1.5; %[m] measure windspeed 
  U(h) = V_inf*(log(h_alt/z0)/log(h_ground/z0));
end
h=1:3000;
figure
plot(U,h)
title 'Logarithmic wind profile '
xlabel 'Speed [m/s]'; ylabel 'Altitude [m]';

%% 


% 
