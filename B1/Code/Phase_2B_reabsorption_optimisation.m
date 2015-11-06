%{
Need to run prior: (takes time so better to run once prior than every time
this program is run
Optimising_standard_deviation
Fraction_absorbed_with_no_reabsorption
%}

%{
OD absorption gaussian from Optimising_standard_deviation
OD_absorption = Max_OD_absorption * Gaussian(Peak_absorption_wavelength,Standard_deviation,0,1100);
%}

%Define variables for loop
Alpha = 0;
loop_var_4 = 1;
Fraction_reaching_PV_vec = zeros(1,100);
Alpha_loop = zeros(1,100);

for sd_var_loop = linspace(30,63.2,100)
    %Establish OD of absorption for current SD
    OD_absorption = Max_OD_absorption * Gaussian(Peak_absorption_wavelength,sd_var_loop,0,1100);
    %Alpha is value of OD_absorption at 940nm i.e. element 940*20+1 of OD
    Alpha = OD_absorption(940*20+1);
    Fraction_reaching_PV_2 = Fraction_photons_absorbed_function(sd_var_loop) * (Phase_two_integral(Alpha));
    Fraction_reaching_PV_vec(loop_var_4) = Fraction_reaching_PV_2;
    
    %Look at values of alpha as a check
    Alpha_loop(loop_var_4) = Alpha;
    loop_var_4 = loop_var_4 + 1;
end

%{
To check alpha calculation works as intended, alpha starts at 0 then rises
exponentially to 6 at 63.2 as expected
plot(linspace(30,63.2,100),Alpha_loop)
%}

%{
%For more precise optimum s.d. use this loop and adjust sd_var_plot later to
%sd_var_plot = linspace(34,35,1000); to give correct graph (takes much
%longer to run, 1000 is probably excessive number of iterations) 

for sd_var_loop = linspace(34,35,1000)
    OD_absorption = Max_OD_absorption * Gaussian(Peak_absorption_wavelength,sd_var_loop,0,1100);
    %Alpha is value of OD_absorption at x = 940
    Alpha = OD_absorption(940*20+1);
    Fraction_reaching_PV_2 = Fraction_photons_absorbed_function(sd_var_loop) * (Phase_two_integral(Alpha));
    Fraction_reaching_PV_vec(loop_var_4) = Fraction_reaching_PV_2;
end

%More precise optimum sd = 34.80
%}

%{
%Suggested in notes to fit polynomial to data to save time, following
%script was used to do so:
%Fraction_reaching_PV_vec_fitted = polyval(polyfit(sd_var_plot, Fraction_reaching_PV_vec,9),sd_var_plot);
%Deemed unneceassary as code only took ~20 seconds to run and polynomial
%would decrease accuracy
%As a check
%plot(sd_var_plot, Fraction_reaching_PV_vec_fitted)
%}

%Plot fraction of photons reaching PV vs standard deviation to
%clearly show the optimal point
sd_var_plot = linspace(30,63.2,100);
plot(sd_var_plot, Fraction_reaching_PV_vec)
xlabel ('Standard Deviation')
ylabel ('Fraction Reaching PV Cell')
title  ('Fraction reaching PV cell using simplified reabsorption estimate')

%Display optimal sd
Phase_two_optimal_SD = sd_var_plot(Fraction_reaching_PV_vec == max(Fraction_reaching_PV_vec));
display (Phase_two_optimal_SD)