function [Phase_4_Max_fraction_reaching_collector, Phase_4_optimal_SD] = Phase_4_Fraction_reaching_PV_Cell(SD_range,Peak_absorption_wavelength, Peak_emission_wavelength,Alpha_var, U_matrix)

load student_data_2012
Max_OD_absorption = Parameters(7);

%Matrix containing alpha values in column 1 and corresponding U in column 2 
%used later for interpolation of U for a given alpha
P2_integral_lookup = [Alpha_var', U_matrix];

%Establish size/starting value of loop variables
loop_var_9 = 1;
Fraction_reaching_PV_cell_vec = zeros(1,length(SD_range));
Phase_4_U_Matrix = zeros(1,length(SD_range));
for SD_Phase_4 = SD_range
    %Alpha is the OD of absorption
    P4_Alpha = Max_OD_absorption * Gaussian(Peak_absorption_wavelength, SD_Phase_4, 0, 1100);
    %Interpolate phase 2 integral results for all values of P3_Alpha
    Phase_2_integral_result = interp1(P2_integral_lookup(:,1), P2_integral_lookup(:,2), P4_Alpha, 'spline');
    %Establish G(lambda)
    P4_Emission_OD = Phase_4_G_Lambda_function(SD_Phase_4,0:0.05:1100,Peak_emission_wavelength);
    %Triple integral to find U
    U_Phase_4_Integrand = P4_Emission_OD .* Phase_2_integral_result;
    U_Phase_4 = trapz(0:0.05:1100,U_Phase_4_Integrand);
    Phase_4_U_Matrix(loop_var_9) = U_Phase_4;
    Phase_4_Fraction_reaching_collector = Phase_4_U_Matrix(loop_var_9) .* Fraction_photons_absorbed_function(SD_Phase_4);
    Fraction_reaching_PV_cell_vec(loop_var_9) = Phase_4_Fraction_reaching_collector;
    loop_var_9 = loop_var_9 + 1;
end

Phase_4_Max_fraction_reaching_collector = max(Fraction_reaching_PV_cell_vec);
Phase_4_optimal_SD = SD_range(Fraction_reaching_PV_cell_vec == Phase_4_Max_fraction_reaching_collector);