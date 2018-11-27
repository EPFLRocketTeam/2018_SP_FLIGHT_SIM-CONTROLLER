function q_dot = quat_evolve(q, w)
% QUAT_EVOLVE returns the time derivative of the quaternion attitude vector
% as a function of the current attitude q and the rotation w expressed in
% the same frame as q.

q_dot = (1 - norm(q))*q +...                % to correct for integration errors 
                         ...                % (c.f. Modeling and Simulation of aerospace 
                         ...                % vehicle dynamics, second edition p.126, Peter H. Zipfel)
              0.5 * [0, w(3), -w(2), w(1);
                    -w(3), 0, w(1), w(2);
                    w(2), -w(1), 0, w(3);
                    -w(1), -w(2), -w(3), 0] * q;
end