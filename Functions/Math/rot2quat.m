function q = rot2quat(C)
% ROT2QUAT computes the quaternion representation of the attitude based on
% the rotation matrix rotating the earth coordinate system to the rocket
% coordinate system.

q = zeros(4,1);
T = trace(C);
qsq = [1+2*C(1,1)-T, 1+2*C(2,2)-T, 1+2*C(3,3)-T, 1+T]/4;
[x,i] = max(qsq);

switch i
    case 4
        q(4) = sqrt(x);
        q(1) = (C(2,3)-C(3,2))/4/q(4);
        q(2) = (C(3,1)-C(1,3))/4/q(4);
        q(3) = (C(1,2)-C(2,1))/4/q(4);
    case 3
        q(3) = sqrt(x);
        q(1) = (C(1,3)+C(3,1))/4/q(3);
        q(2) = (C(3,2)+C(2,3))/4/q(3);
        q(4) = (C(1,2)-C(2,1))/4/q(3);
    case 2
        q(2) = sqrt(x);
        q(1) = (C(1,2)+C(2,1))/4/q(2);
        q(3) = (C(3,2)+C(2,3))/4/q(2);
        q(4) = (C(3,1)-C(1,3))/4/q(2);
    case 1
        q(1) = sqrt(x);
        q(2) = (C(1,2)+C(2,1))/4/q(1);
        q(3) = (C(1,3)+C(3,1))/4/q(1);
        q(4) = (C(2,3)-C(3,2))/4/q(1);
end