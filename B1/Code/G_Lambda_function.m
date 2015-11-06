function [G_Lambda] = G_Lambda_function(standard_deviation_var, Wavelength_range)

load student_data_2012
Peak_emission_wavelength = Parameters(8);
x = Wavelength_range;

%Parameters for G(Lambda)
G_Lambda_not_normalised = exp((-(x-Peak_emission_wavelength).^2)/(2*((standard_deviation_var)^2)));

%Normalise to have area 1 (as it's a probabilty distribution)
Normalisation_factor = 1/(trapz (Wavelength_range, G_Lambda_not_normalised));
G_Lambda = G_Lambda_not_normalised * Normalisation_factor;