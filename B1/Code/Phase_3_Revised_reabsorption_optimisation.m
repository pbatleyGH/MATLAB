%G_Lambda check
plot(0:0.05:1100, G_Lambda_function(30,0:0.05:1100), 0:0.05:1100, G_Lambda_function(35,0:0.05:1100), 0:0.05:1100, G_Lambda_function(40,0:0.05:1100), 0:0.05:1100, G_Lambda_function(45,0:0.05:1100), 0:0.05:1100, G_Lambda_function(50,0:0.05:1100), 0:0.05:1100, G_Lambda_function(55,0:0.05:1100), 0:0.05:1100, G_Lambda_function(60,0:0.05:1100))
xlabel ('Wavelength/nm')
ylabel ('Probability')
legend ('30nm', '35nm', '40nm', '45nm', '50nm', '55nm', '60nm')
axis   ([600 1100 0 0.015])
title  ('G for different standard deviations')

%Matrix containing alpha values in column 1 and corresponding U in column 2 
%used later for interpolation of U for a given alpha
P2_integral_lookup = [Alpha_var', U_matrix];

%Range of SD values to loop, 
SD_Phase_3_var = linspace(0,63.2,100);

loop_var_7 = 1;
Phase_3_U_Matrix = zeros(1,length(SD_Phase_3_var));
for SD_Phase_3 = SD_Phase_3_var
    %Alpha is the OD of absorption
    P3_Alpha = Max_OD_absorption * Gaussian(Peak_absorption_wavelength, SD_Phase_3, 0, 1100);
    %Interpolate phase 2 integral results for all values of P3_Alpha
    Phase_2_integral_result = interp1(P2_integral_lookup(:,1), P2_integral_lookup(:,2), P3_Alpha, 'spline');
    %Establish G(lambda)
    P3_Emission_OD = G_Lambda_function(SD_Phase_3,0:0.05:1100);
    %Triple integral to find U
    U_Phase_3_Integrand = P3_Emission_OD .* Phase_2_integral_result;
    U_Phase_3 = trapz(0:0.05:1100,U_Phase_3_Integrand);
    Phase_3_U_Matrix(loop_var_7) = U_Phase_3;
    loop_var_7 = loop_var_7 + 1;
end

%Interpolation check
figure
SD_Check = 34.8;
P3_Alpha_check = Max_OD_absorption * exp((-((0:0.05:1100 - Peak_absorption_wavelength).^2))/(2*(SD_Check^2)));
Interpolation_check = interp1(P2_integral_lookup(:,1), P2_integral_lookup(:,2), P3_Alpha_check, 'spline');

subplot (1,2,1), semilogx(P2_integral_lookup(:,1), P2_integral_lookup(:,2), 'ro', P3_Alpha_check, Interpolation_check, 'b')
xlabel ('Alpha')
ylabel ('U (Phase 2)')
legend ('U (Phase 2)','Interpolation')
title  ('Phase 2 U interpolation check')
axis ([1e-4 1e2 0 0.8])
subplot (1,2,2), semilogx(P2_integral_lookup(:,1), P2_integral_lookup(:,2), 'ro', P3_Alpha_check, Interpolation_check, 'b.')
xlabel ('Alpha')
ylabel ('U (Phase 2)')
legend ('U (Phase 2)','Interpolation')
title  ('Phase 2 U interpolation check zoomed in')
axis ([1e-1 1.6e-1 0.4 0.5])

%Check Phase 3 integration
figure
plot(SD_Phase_3_var,Phase_3_U_Matrix)
xlabel ('Standard Deviation/nm')
ylabel ('U')
title ('Check of the Phase 3 Integration')

%Loops separated for clarity
loop_var_8 = 1;
Phase_3_Fraction_reaching_PV_vec = zeros(1,length(SD_Phase_3_var));
for SD_Phase_3 = SD_Phase_3_var
    Phase_3_Fraction_reaching_PV = Phase_3_U_Matrix(loop_var_8) .* Fraction_photons_absorbed_function(SD_Phase_3);
    Phase_3_Fraction_reaching_PV_vec(loop_var_8) = Phase_3_Fraction_reaching_PV;
    loop_var_8 = loop_var_8 + 1;
end

%Plot standard deviation vs fraction reaching PV cell
figure
plot(SD_Phase_3_var,Phase_3_Fraction_reaching_PV_vec)
xlabel ('Standard Deviation/nm')
ylabel ('Fraction of photons reaching PV cell')
title  ('Standard deviation optimisation with revised reabsorption')

%Output optimal standard deviation and max fraction reaching PV cell
Max_fraction_reaching_PV = max(Phase_3_Fraction_reaching_PV_vec);
Phase_3_optimal_SD = SD_Phase_3_var(Phase_3_Fraction_reaching_PV_vec == Max_fraction_reaching_PV);
display(Phase_3_optimal_SD)
display(Max_fraction_reaching_PV)

%Final plot showing all spectra (scaled for indication only)
Phase_3_OD_absorption = Max_OD_absorption * Gaussian(Peak_absorption_wavelength, Phase_3_optimal_SD,0,1100);
figure
plot(0:0.05:1100, 1.15e-2*Phase_3_OD_absorption, 0:0.05:1100, 0.9e2 * G_Lambda_function(Phase_3_optimal_SD,0:0.05:1100),XYZ_Wavelengths, CIE_X)
xlabel ('Wavelength/nm')
ylabel ('Arbitrary units for indication only')
axis ([380 1100 0 1.3])
title ('Plot showing absorption, emission and red spectra for indication of positions and widths')
legend ('Absorption','Emission','Red photoreceptor')