%Fraction absorbed
P1_Fraction_absorbed = Fraction_photons_absorbed_function(Standard_deviation);

%TIR
Critical_angle = asin(Parameters(4)/Parameters(1));

%Fraction TIR = cosine critical angle
FTIR = cos(Critical_angle);

%Fraction reaching PV cell
P1_Fraction_Reaching_PV_Cell = FTIR * P1_Fraction_absorbed;
display(P1_Fraction_absorbed)
display(FTIR)
display(P1_Fraction_Reaching_PV_Cell)