function [value, isterminal, direction] = myEventRail(T1,X1)
%   Stop simulation at apogee
value = (X1(1)-5);   % Stop at end of rail
isterminal = 1; % Stop the integration
direction = 1;
end

