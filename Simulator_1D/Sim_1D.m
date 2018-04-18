function [T, X] = Sim_1D(Rocket, Env, tspan, x0, CD_AB, EventType, EventVal, EventDir)

switch(EventType)
    case 'Altitude'
        Option = odeset('events', @AltEvent)
    case 'Velocity'
        Option = odeset('events', @SpeedEvent)
    otherwise
        Option = [];
end

[T, X] = ode45(@(t,x) Rocket_Kinematic_R2(t, x, Rocket, Env, CD_AB), tspan, x0, Option);

    function [value, isterminal, direction] = AltEvent(T,X)
        %   Stop simulation at apogee
        value = X(1)-EventVal;   % altitude reaches beginning of burn phase
        isterminal = 1; % Stop the integration
        direction = EventDir;      
    end

    function [value, isterminal, direction] = SpeedEvent(T,X)
        %   Stop simulation at apogee
        value = X(2)-EventVal;   % altitude reaches beginning of burn phase
        isterminal = 1; % Stop the integration
        direction = EventDir;      
    end

end