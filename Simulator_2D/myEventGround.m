function [value, isterminal, direction] = myEventGround(T,X)
%   Stop simulation at apogee
value = X(3);   % Altitude = 0
isterminal = 1; % Stop the integration
direction = +1;
end

