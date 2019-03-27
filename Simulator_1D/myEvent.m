function [value, isterminal, direction] = myEvent(T,X)
%   Stop simulation at apogee
value = X(2);   % Speed at apogee = 0
isterminal = 1; % Stop the integration
direction = -1;
end

