close all;
clear all;

% parameters
n = 10;
d = 122.8;
alpha = [ -171.33, -152.167, -133, -113.834, -94.6675, -75.501, -56.3345, -37.168, -18.0015, 1.165];
h = []; l = []; scale = [];

% read image of shuriken
for i = 1:n
    
    if i < 10
        img = imread(['Characterize_AB/AB_0' num2str(i) '.png' ]);
    else 
        img = imread(['Characterize_AB/AB_' num2str(i) '.png' ]);
    end
    
    image(img);
    daspect([1,1,1]);
    
    % scaleing
    display('Select two points diametrically opposed.');
    [x, y] = ginput(2);
    d_m = sqrt((x(2)-x(1))^2+(y(2)-y(1))^2);
    scale_m = d/d_m;
    scale = [scale, scale_m];
    
    display('Select 2 points for the base of the winglet, then select the tip.');
    [x, y] = ginput(3);
    
    l_m = sqrt((x(2)-x(1))^2+(y(2)-y(1))^2);
    l = [ l, scale_m*l_m];
    H = ((x(2)-x(1))*(x(3)-x(1))+(y(2)-y(1))*(y(3)-y(1)))/l_m^2*[x(2)-x(1), y(2)-y(1)]+[x(1), y(1)];
    h = [ h, scale_m*sqrt((H(1)-x(3))^2+(H(2)-y(3))^2)];
end