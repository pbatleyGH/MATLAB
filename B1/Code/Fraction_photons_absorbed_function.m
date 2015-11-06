function [Fraction] = Fraction_photons_absorbed_function(Standard_deviation_var)

load student_data_2012
P_lambda = Wavelength_in_nm .* Power_Density_Spectrum / (Parameters(10) * Parameters(11));

%Parameters required for function
Thickness = Parameters(2);
Max_OD_absorption = Parameters(7);
Peak_absorption_wavelength = Parameters(5);

%Optical Density
OD_absorption = Max_OD_absorption * Gaussian(Peak_absorption_wavelength,Standard_deviation_var,0,1100);

%Condition OD_absorption for simplicity when integrating. Gaussian function gives resolution of 1/20 so
%only take every 20th element to give unit incremental x values
OD_absorption_conditioned = OD_absorption(1:20:((1100*20)+1));

Integrand = P_lambda([1:2:241,242:941]).*(1-exp(-(OD_absorption_conditioned(281:1101)'*Thickness)));
Fraction = trapz (Integrand)/ trapz(Wavelength_in_nm, P_lambda);