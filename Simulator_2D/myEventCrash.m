function [value, isterminal, direction] = myEventCrash(T,X)
%   Stop simulation at crash
value = (X(3)>0)-0.5;   % Rocket crashes back to ground at AGL = 0
isterminal = 1; % Stop the integration
direction = -1;
end

