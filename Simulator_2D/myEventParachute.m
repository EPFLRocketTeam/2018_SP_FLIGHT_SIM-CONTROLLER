function [value, isterminal, direction] = myEventParachute(T,X)
%   Stop simulation at apogee
value = (X(3)>0)-0.5;   % Stop at touch down
isterminal = 1; % Stop the integration
direction = -1;
end