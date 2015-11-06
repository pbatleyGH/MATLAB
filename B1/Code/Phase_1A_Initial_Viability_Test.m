%16/11/2012
load student_data_2012

%Red absorption spectrum
CIE_X = CIE_XYZ(:,1);

%Photon Flux Density
P_lambda = Wavelength_in_nm .* Power_Density_Spectrum / (Parameters(10) * Parameters(11));

%Comparison between power density spectrum and photon density spectrum for
%checking
subplot(1,2,1), plot(Wavelength_in_nm, Power_Density_Spectrum)
xlabel('Wavelength/nm')
ylabel('Power Spectral Density/Wm ^{-2}nm^{-1}')
title ('Power Spectral Density of incoming light D(\lambda)')
axis ([280 1100 0 1.8])
%1e-9 factor gives slightly nicer units
subplot(1,2,2), plot(Wavelength_in_nm, P_lambda.*1e-9)
xlabel('Wavelength/nm')
ylabel('Photon Flux Density/sm ^{-2}nm^{-1}')
title ('Photon Flux Density of incoming light P(\lambda)')
axis ([280 1100 0 5e18])

%{
x axis for CIE runs from 360 to 830 in increments of 1

x axis for photon flux density (PFD) runs from 280 - 1100. Increments of 0.5
from 280 - 400

Adjust PFD matrix to contain just 360 - 830 in increments of 1
From manual lookup, 360 corresponds to element 161 of vector Wavelength_in_nm
Elements 161, 163, 165... 241 (only odd numbers) required to give 360 - 400 in increments of
1 then elements 242 - 671 required to give 401-830.
%}

%Red absorption spectrum to red photons matrix adjustment
Adjustment_elements = [161:2:241,242:671];
Wavelength_in_nm_adjusted = Wavelength_in_nm(Adjustment_elements);
Red_absorption_photons = P_lambda(Adjustment_elements) .* CIE_X;


%Graph showing difference between flat PDS assumption and actual (graphs
%scaled to same size just for comparison) to Check that adjusted matrix has
%worked as expected
figure
plot (XYZ_Wavelengths, CIE_X, XYZ_Wavelengths, Red_absorption_photons*0.25*10^-27)
xlabel ('Wavelength/nm')
ylabel ('Relative Sensitivity')
legend ('Sensitivity of red photoreceptor','Red photon density spectrum')
title ('Comparison: Red Photoreceptor Spectrum vs Red PFD Spectrum')

%Loop incrementing wavelength and calculating intergral of 'red' photon
%flux density spectrum up to this wavelength
%Finds the wavelength such that 99% of the 'red' photon flux density 
%spectrum is contained below this wavelength
Total_absorbed_red_photons = trapz(XYZ_Wavelengths,Red_absorption_photons);
loop_var_1 = 1;
for loop_var_1 = 1:length(XYZ_Wavelengths)
    Red_photons_temp_1 = trapz(Red_absorption_photons(1:loop_var_1));
    Percentage_red_absorbed = Red_photons_temp_1/Total_absorbed_red_photons;
    if Percentage_red_absorbed < 0.99
        loop_var_1 = loop_var_1 + 1;
    else
        break
    end
end

%Calculate percentage of total photons available for PV cell
temp_1 = length(find(XYZ_Wavelengths <= XYZ_Wavelengths(loop_var_1)));
P_lambda_adjusted = P_lambda(Adjustment_elements);
Photons_available_for_PV_cell = 1 - trapz(P_lambda_adjusted(1:temp_1))/trapz(Wavelength_in_nm,P_lambda);

%Output results of min wavelength for 99% red and percentage of total
%photons available
display (XYZ_Wavelengths(loop_var_1))
display (Photons_available_for_PV_cell)