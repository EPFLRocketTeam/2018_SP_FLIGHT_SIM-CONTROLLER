function C = rotmat(a, ax)
%ROTMAT generates the rotation matrix in cartesian coordinates of angle a 
% around axes ax. 

switch(ax)
    case 1
        C = [   1,      0,      0;
                0,      cos(a), -sin(a);
                0,      sin(a),cos(a)];
    case 2
        C = [   cos(a), 0,      sin(a);
                    0,  1,      0;
                -sin(a),0,      cos(a)];
    case 3
        C = [    cos(a), -sin(a),    0;
                sin(a),cos(a),     0;
                      0,        0,  1];
    otherwise
        error('Error: In ROTMAT, Axes number must be between 1 and 3.');
end
end