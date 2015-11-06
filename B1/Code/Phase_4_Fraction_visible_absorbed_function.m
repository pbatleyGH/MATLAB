function [Integral_impact_on_visible_wavelengths] = Phase_4_Fraction_visible_absorbed_function(Standard_deviation_var, Peak_absorption_wavelength)

%Calculating fraction of red receptor spectrum absorbed

%Initial data
load student_data_2012

%Red absorption spectrum
CIE_X = CIE_XYZ(:,1);
Thickness = Parameters(2);
Max_OD_absorption = Parameters(7);

%Script originally had fixed standard deviation but for function use,
%variable s.d. input was introduced
%Standard_deviation = Parameters(6);

OD_absorption = Max_OD_absorption * Gaussian(Peak_absorption_wavelength,Standard_deviation_var,0,1100);

%Condition OD_absorption for simplicity when integrating. Gaussian function gives resolution of 1/20 so
%only take every 20th element to give unit x values
OD_absorption_conditioned = OD_absorption(1:20:22000);

%Integrate between lambda min and lambda max the function:
%CIE_X * (1 - exp(-OD.t))
Lambda_min = 1;
Lambda_max = 471;
Integrand_impact_on_visible_wavelengths = CIE_X(Lambda_min:Lambda_max).*(1-exp(-(OD_absorption_conditioned(Lambda_min+XYZ_Wavelengths(1):Lambda_max+XYZ_Wavelengths(1)))'*Thickness));
Integral_impact_on_visible_wavelengths = trapz(Integrand_impact_on_visible_wavelengths)/ trapz(CIE_X(Lambda_min:Lambda_max));