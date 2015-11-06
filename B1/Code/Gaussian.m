function Gauss = Gaussian(mean,standard_deviation,Gauss_x_min,Gauss_x_max)

    x = linspace(Gauss_x_min,Gauss_x_max,((Gauss_x_max-Gauss_x_min)*20)+1);
    Gauss = exp((-(x-mean).^2)/(2*((standard_deviation)^2)));

%Just to check
%plot (x,Gauss)
%Does work correctly