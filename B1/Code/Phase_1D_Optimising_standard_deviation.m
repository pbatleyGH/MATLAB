%First iteration in incriments of 1 gave x = 63
%Start more accurate search at x = 63 to reduce time taken
Phase_1_SD_loop = 63;
loop_var_2 = 0;

while loop_var_2 < 0.01;
    loop_var_2 = Fraction_visible_absorbed_function(Phase_1_SD_loop);
    Phase_1_SD_loop = Phase_1_SD_loop + 0.01;
end

P1_Fraction_reaching_PV_cell_optimal = FTIR * Fraction_photons_absorbed_function(Phase_1_SD_loop-0.01);

%SD is incrimented one time too many during loop execution
display(Phase_1_SD_loop-0.01)
display(P1_Fraction_reaching_PV_cell_optimal)

%check
plot(XYZ_Wavelengths, Red_absorption_photons*2e-26, linspace(0,1100,1100), OD_absorption_conditioned(1:1100))
xlabel ('Wavelength/nm')
ylabel ('Optical Density of Absorption')
title  ('Overlap between absorption spectrum and red photon flux density spectrum (indication only)')
axis ([390 900 0 110])