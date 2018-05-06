function [value, isterminal, direction] = CrashEvent(T,X)
%   Stop simulation at apogee
value = (X(3)>0)-0.5;   % Rocket reaches the same altitude as where it was launched
isterminal = 1; % Stop the integration
direction = -1; % detect descending values
end