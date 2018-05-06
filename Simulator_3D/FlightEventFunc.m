function [value, isterminal, direction] = FlightEventFunc(T,X)

[v_apogee, it_apogee, d_apogee] = ApogeeEvent(T,X);
[v_crash, it_crash, d_crash] = CrashEvent(T,X);

value = [v_apogee, v_crash]; isterminal = [it_apogee, it_crash]; direction = [d_apogee, d_crash];
end