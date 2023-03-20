function log_S_S0 = fun_lsqcurfit_ADC_Kurtosis(D, xdata)

log_S_S0 = -D(1).*xdata + (D(1).^2).*D(2).*(xdata.^2)./6;