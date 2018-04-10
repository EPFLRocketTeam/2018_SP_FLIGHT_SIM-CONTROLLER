function q_dot = quat_evolve(q, w)
% QUAT_EVOLVE returns the time derivative of the quaternion attitude vector
% as a function of the current attitude q and the rotation w expressed in
% the same frame as q.

q_dot = 0.5 * [0, w(3), -w(2), w(1);
                    -w(3), 0, w(1), w(2);
                    w(2), -w(1), 0, w(3);
                    -w(1), -w(2), -w(3), 0] * q;
end