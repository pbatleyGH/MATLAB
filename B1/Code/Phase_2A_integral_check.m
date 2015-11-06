%Check phase two integral for a range of alpha values
%Expect alpha -> 0, U -> critical angle = 0.724

%Declate variables for loop
k = 1;
Alpha_var = logspace(-4,2,100);
U_matrix = zeros(length(Alpha_var),1);

for loop_var_3 = Alpha_var;
    U = Phase_two_integral(loop_var_3);
    U_matrix(k) = U;
    k = k + 1;
end

%check
semilogx(Alpha_var, U_matrix)
xlabel ('Alpha')
ylabel ('U')
title  ('U for a range of alpha values')
%saved as Alpha_vs_Phase_2_Integral_Plot