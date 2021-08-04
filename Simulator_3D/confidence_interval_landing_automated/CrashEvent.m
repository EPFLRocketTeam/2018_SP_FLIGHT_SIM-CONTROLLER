function [value, isterminal, direction] = CrashEvent(T,X,Environnement)
%   Stop simulation at apogee

z=X(3)-find_altitude(X(1),X(2),Environnement);

value = (z>0)-0.5;   % Rocket reaches the same altitude as where it was launched
isterminal = 1; % Stop the integration
direction = -1; % detect descending values
end
