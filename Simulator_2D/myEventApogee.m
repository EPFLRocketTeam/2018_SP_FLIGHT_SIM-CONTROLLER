function [value, isterminal, direction] = myEventApogee(T,X)
%   Stop simulation at apogee
value = X(4);   % Speed at apogee = 0
isterminal = 1; % Stop the integration
direction = -1;
end

