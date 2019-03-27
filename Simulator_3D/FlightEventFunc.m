function [value, isterminal, direction] = FlightEventFunc(T,X)

[value(1), isterminal(1), direction(1)] = ApogeeEvent(T,X);
%[value(2), isterminal(2), direction(2)] = CrashEvent(T,X);
end