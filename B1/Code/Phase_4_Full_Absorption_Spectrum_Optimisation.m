%Parameter ranges to loop
Wavelength_range = linspace(700,750,11);
Visible_threshold = 0.01;

%Define loop variable sizes/starting values
loop_var_10 = 1;
Optimal_SD = zeros(length(Wavelength_range),1);
P4_Max_Fraction_vec = zeros(length(Wavelength_range), 1);
P4_Fraction_visible = zeros(length(Wavelength_range),1);
P4_SD_loop_1 = 10;
Visible_overlap = 0;

for Peak_absorption_wavelength_loop = Wavelength_range
    %Reset while loop variables on each loop
    P4_SD_loop_1 = 10;
    Visible_overlap = 0;
    %For given peak absorption wavelength, find maximum sd that corresponds
    %to visible light limit
    while Visible_overlap < Visible_threshold;
        Visible_overlap = Phase_4_Fraction_visible_absorbed_function(P4_SD_loop_1,Peak_absorption_wavelength_loop);
        P4_SD_loop_1 = P4_SD_loop_1 + 0.01;
    end
    %Set this SD as the cap for the range of SD optimised over
    SD_range = 10:0.05:(P4_SD_loop_1-0.01);
    %Get maximum fraction absorbed (C) and optimal SD (D)
    [C,D] = Phase_4_Fraction_reaching_PV_Cell(SD_range,Peak_absorption_wavelength_loop,940,Alpha_var,U_matrix);
    %Create vectors of these for plotting
    P4_Max_Fraction_vec(loop_var_10) = C;
    Optimal_SD(loop_var_10) = D;
    loop_var_10 = loop_var_10 + 1;
end

plot(Wavelength_range, P4_Max_Fraction_vec)
xlabel ('Wavelength/nm')
ylabel ('Fraction of photons reaching PV cell')
title  ('Fraction of photons reaching PV cell with full absoprtion optimisation')

%{
Optimal SD plot, not actually particularly useful
figure
plot(Wavelength_range, Optimal_SD)
xlabel ('Wavelength/nm')
ylabel ('Standard deviation')
%Remember to update %threshold in the title
title  ('Optimal standard deviation vs wavelength')
%}

%{
Comparison plot
figure
plot(Wavelength_range, P4_Max_Fraction_vec, Wavelength_range, 1.3075e-3 * Optimal_SD)
xlabel ('Wavelength/nm')
ylabel ('Fraction of photons reaching PV cell (indication only)')
title  ('Comparison of maximum photons reaching PV cell and optimal SD')
legend ('Fraction reaching PV cell','Optimal SD')
%}

load Phase_4_Results.mat
%Output results
P4_Max_Wavelength = Wavelength_range((find(P4_Max_Fraction_vec == max(P4_Max_Fraction_vec))));
P4_Max_Fraction = P4_Max_Fraction_vec(P4_Max_Fraction_vec == max(P4_Max_Fraction_vec));
display(Visible_threshold)
display(P4_Max_Wavelength)
display(P4_Max_Fraction)


%Store maximum values if wavelength loop was fine enough
%Requires program to be run manually several times, only allows fractions
%greater than 0.001
%IMPORTANT: Ensure that wavelength range encompasses maxmimum before increasing number
%of iterations > 50
if(length(Wavelength_range) > 50)
    P4_Final_Fraction(Visible_threshold*1000) = P4_Max_Fraction;
    P4_Final_Wavelength(Visible_threshold*1000) = P4_Max_Wavelength;
    
    %{
    Interpolation introduced below for better plots
    
    %Only plot extra figures if fine loop is being used to save multiple
    %figures appearing when more frequently used coarse loop is run
    figure
    plot((find(P4_Final_Fraction>0)/10), P4_Final_Fraction(P4_Final_Fraction>0))
    xlabel ('Visible light threshold (%)')
    ylabel ('Fraction reaching PV cell')
    title  ('Optimisation of fraction reaching PV cell for given visible light threshold')
    figure
    plot((find(P4_Final_Wavelength>0)/10), P4_Final_Wavelength(P4_Final_Wavelength>0))
    xlabel ('Visible light threshold (%)')
    ylabel ('Optimal Wavelength')
    title  ('Optimal absorption wavelength for given visible light threshold')
    %}    
end

%Store results for future reference as they take a long time to generate
save('Phase_4_Results','P4_Final_Fraction','P4_Final_Wavelength')

%Backup set of results saved as 'Phase_4_Results_Backup'. Given the length
%of time that this script takes to run, it seemed sensible to save the
%results to a separate file in case 'Phase_4_Results' was written to
%incorrectly and had to be restarted

%Finally, interpolate these results to give a smoother curve of fraction
%reaching PV cell vs. visible light threshold
P4_Wavelength_Interp = interp1((find(P4_Final_Wavelength>0)/10), P4_Final_Wavelength(P4_Final_Wavelength>0),1:0.1:20, 'spline');
P4_Fraction_Interp = interp1((find(P4_Final_Fraction>0)/10),P4_Final_Fraction(P4_Final_Fraction>0),1:0.1:20,'spline');

figure
plot(1:0.1:20, P4_Wavelength_Interp)
xlabel ('Visible light threshold (%)')
ylabel ('Optimal Wavelength')
title  ('Optimal absorption wavelength for given visible light threshold')
figure
plot(1:0.1:20, P4_Fraction_Interp)
xlabel ('Visible light threshold (%)')
ylabel ('Fraction reaching PV cell')
title  ('Optimisation of fraction reaching PV cell for given visible light threshold')