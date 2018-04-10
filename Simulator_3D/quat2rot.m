function C = quat2rot(q)
% QUAT2ROT Compute rotation matrix from rotation described by quaternion q.

q4 = q(4);
q = q(1:3);
S = [0 -q(3) q(2); q(3) 0 -q(1); -q(2) q(1) 0];
C = (q4^2 - q'*q)*eye(3) + 2*(q*q') - 2*q4*S;

end