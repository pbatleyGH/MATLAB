function P2_integral = Phase_two_integral(Alpha)

load student_data_2012

%Parameters in integral
L = Parameters(3);
Critical_angle = asin(Parameters(4)/Parameters(1));

%Limits
Theta_min = Critical_angle;
Theta_max = pi()/2;

Phi_min = 0;
Phi_max = pi()/2;

y_min = 0;
y_max = L;

%Set up integrand function
P2_integrand = @(y, Phi, Theta)(exp(-(Alpha*y)/(sin(Theta)*sin(Phi))) + exp(-(Alpha*(2*L-y))/(sin(Theta)*sin(Phi)))) * sin(Theta);
%Triple integration
P2_integral = (1/(pi()*L))*triplequad(P2_integrand, y_min, y_max, Phi_min, Phi_max, Theta_min, Theta_max);