function [value, isterminal, direction] = ApogeeEvent(T,X)
%   Stop simulation at apogee
value = X(6);   % ascent speed = 0
isterminal = 1; % Stop the integration
direction = -1; % detect descending values
end

