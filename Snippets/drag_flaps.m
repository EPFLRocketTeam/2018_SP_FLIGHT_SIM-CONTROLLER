function CD = drag_flaps(Rocket, phi, alpha, Uinf, nu)

% parameters
CD0 = 1.17;
w = 0.106;
b = 0.089;
S = w*b;
U = abs(Uinf*cos(alpha));
Rex = Rocket.ab_x*U/nu;
delta = 0.37*Rocket.ab_x/Rex^0.2;

% drag coefficient
if phi<asind(delta/w)
    qr = 7/9*(w*sind(phi)/delta)^(2/7);
else
    qr = 1 - 2/9*(delta/w/sind(phi));
end
CD = Rocket.ab_n*CD0*qr*S/Rocket.Sm*sind(phi)^3;

end