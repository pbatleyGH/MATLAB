%It is assumed from this point onwards that all prior scripts have been run
%in the correct order to produce all necessary variables

%Renaming parameters for clarity of code
Thickness = Parameters(2);
Max_OD_absorption = Parameters(7);
Peak_absorption_wavelength = Parameters(5);
Standard_deviation = Parameters(6);

%Optical Density
OD_absorption = Max_OD_absorption * Gaussian(Peak_absorption_wavelength,Standard_deviation,0,1100);

%Condition OD_absorption for simplicity when integrating. Gaussian function gives resolution of 1/20 so
%only take every 20th element to give unit incremental x values
OD_absorption_conditioned = OD_absorption(1:20:((1100*20)+1));

%Integrate between lambda min and lambda max the function:
%CIE_X * (1 - exp(-OD.t))
Lambda_min = 1;
Lambda_max = 471;
Integrand_impact_on_visible_wavelengths = CIE_X(Lambda_min:Lambda_max).*(1-exp(-(OD_absorption_conditioned(Lambda_min+XYZ_Wavelengths(1):Lambda_max+XYZ_Wavelengths(1)))'*Thickness));
Integral_impact_on_visible_wavelengths = trapz (Integrand_impact_on_visible_wavelengths)/ trapz(CIE_X(Lambda_min:Lambda_max));

display(Integral_impact_on_visible_wavelengths)