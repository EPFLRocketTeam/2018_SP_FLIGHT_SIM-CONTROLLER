function [value, isterminal, direction] = RailEvent(T,X, Environment)
%   Stop simulation at apogee
value = X(1)-Environment.Rail_Length;   % ascent speed = 0
isterminal = 1; % Stop the integration
direction = 1; 
end