clear;
close all;
clc;

nTps = [101,1001,10001,100001];
figure
for i=1:4
    ntps = nTps(i);
    t0 = 0;
    tf = 1e4;
    tspan = linspace(tf,t0,ntps);
    % Changer à -1 pour la simulation inverse
    dir = 1;
    subplot(2,2,i);
    for mu=1:5
        [T,X] = ode45(@(t,x) VanDerPol(t,x, mu, dir),tspan,[-2;0]);

        plot(X(:,1),X(:,2),'DisplayName',['mu = ' num2str(mu)])
        hold on;
    end
    % Inverser t0 et tf ici pour la simulation inverse
    title(['t0 = ' num2str(t0) ', tf = ' num2str(tf) ', n = ' num2str(ntps)])
    legend show

end

function xdot = VanDerPol(t,x, mu, dir)

% State initialization:
xdot = zeros(2,1);

% Behaviour Equation:
xdot(1) = dir*mu*(x(1)-1/3*x(1).^3-x(2));
xdot(2) = dir*1/mu*x(1);

end