%spectra plot code

whiteLight=importdata('whiteLight.txt');
white_vals=whiteLight.data(1:end,2);
white_lambda=whiteLight.data(1:end,1);

figure(1)
plot(white_lambda, white_vals)
title("White Light")
xlabel("Wavelength")
ylabel("POWER FIX THIS WRONG")

redLight=importdata('redLight.txt');
red_vals=redLight.data(1:end,2);
red_lambda=redLight.data(1:end,1);

redSatLight=importdata('redLight_saturated.txt');
red_sat_vals=redSatLight.data(1:end,2);
red_sat_lambda=redSatLight.data(1:end,1);

