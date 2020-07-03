function [aire ,r_ellipse,r_ellipse1, X0, Y0, data] = landing_tool(n_sim, angle1, azimuth, Rocket_0, SimOutputs, name_of_environnment) 
coordsx = 1:n_sim;
coordsy = 1:n_sim;
for i = 1 : n_sim
    x = ones(4,1);
    a = normrnd(x,0.03);
    Rocket = setfield(Rocket_0, 'CD_fac' , a(1));
    Rocket = setfield(Rocket, 'CNa_fac' , a(2));
    Rocket = setfield(Rocket, 'cp_fac' , a(3));
    Rocket = setfield(Rocket, 'motor_fac' , a(4));
    Environment =environnementReader(name_of_environnment);
    if(azimuth ~= -1)
        Environment = setfield(Environment, 'Rail_Azimuth', azimuth);
    end
    SimObj = multilayerwindSimulator3D(Rocket, Environment, SimOutputs);
    [T1, S1] = SimObj.RailSim();
    [T2_1, S2_1, ~, ~, ~] = SimObj.FlightSim([T1(end) SimObj.Rocket.Burn_Time(end)], S1(end, 2));
    [T2_2, S2_2, ~, ~, ~] = SimObj.FlightSim([T2_1(end) 40], S2_1(end, 1:3)', S2_1(end, 4:6)', S2_1(end, 7:10)', S2_1(end, 11:13)');
    T2 = [T2_1; T2_2(2:end)];
    S2 = [S2_1; S2_2(2:end, :)];
    [T3, S3, ~, ~, ~] = SimObj.DrogueParaSim(T2(end), S2(end,1:3)', S2(end, 4:6)');
    [~, S4, ~, ~, ~] = SimObj.MainParaSim(T3(end), S3(end,1:3)', S3(end, 4:6)');
    coordsx(i)=S4(end,1);  
    coordsy(i)=S4(end,2);
end

%please look at https://www.visiondummy.com/2014/04/draw-error-ellipse-representing-covariance-matrix/
% Create some random data
y1 = coordsx;
y2 = coordsy;
data = [y1.' y2.'];

% Calculate the eigenvectors and eigenvalues
covariance = cov(data);
[eigenvec, eigenval ] = eig(covariance);

% Get the index of the largest eigenvector
[largest_eigenvec_ind_c, r] = find(eigenval == max(max(eigenval)));
largest_eigenvec = eigenvec(:, largest_eigenvec_ind_c);

% Get the largest eigenvalue
largest_eigenval = max(max(eigenval));

% Get the smallest eigenvector and eigenvalue
if(largest_eigenvec_ind_c == 1)
    smallest_eigenval = max(eigenval(:,2));
else
    smallest_eigenval = max(eigenval(:,1));
end

% Calculate the angle between the x-axis and the largest eigenvector
angle = atan2(largest_eigenvec(2), largest_eigenvec(1));

% This angle is between -pi and pi.
% Let's shift it such that the angle is between 0 and 2pi
if(angle < 0)
    angle = angle + 2*pi;
end

% Get the coordinates of the data mean
avg = mean(data);

% Get the 95% confidence interval error ellipse
chisquare_val = 2.4477;
theta_grid = linspace(0,2*pi);
phi = angle;
X0=avg(1);
Y0=avg(2);
a=chisquare_val*sqrt(largest_eigenval);
b=chisquare_val*sqrt(smallest_eigenval);

% the ellipse in x and y coordinates 
ellipse_x_r  = a*cos( theta_grid );
ellipse_y_r  = b*sin( theta_grid );

%Define a rotation matrix
R = [ cos(phi) sin(phi); -sin(phi) cos(phi) ];

%let's rotate the ellipse to some angle phi
r_ellipse = [ellipse_x_r;ellipse_y_r]' * R;

% Get the 99.99% confidence interval error ellipse
chisquare_val1 = 4.29;
a1=chisquare_val1*sqrt(largest_eigenval);
b1=chisquare_val1*sqrt(smallest_eigenval);

% the ellipse in x and y coordinates 
ellipse_x_r1  = a1*cos( theta_grid );
ellipse_y_r1  = b1*sin( theta_grid );

%let's rotate the ellipse to some angle phi
r_ellipse1 = [ellipse_x_r1;ellipse_y_r1]' * R;

aire = a * b * pi;

