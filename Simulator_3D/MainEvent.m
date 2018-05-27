function [value, isterminal, direction] = MainEvent(T, X, Rocket)
% MAINEVENT event function to detect unreefing altitude

value = (X(3)>Rocket.para_main_event) - 0.5;
isterminal = 1;
direction = -1;
end