close all
clear all

xdata = [7.87, 13.15, 18.43, 23.71, 28.99, 34.27, 39.55, 44.83];  %TE
ydata = [324, 290, 261, 238, 214, 184, 175, 166];  %SI

% model: SI = A * exp(-TE/T2*)
% nonlinear model --> 'fitnlm'

B0 = [400, 50];
yf = @(b, xdata)(b(1)*exp(-xdata./b(2)));
tbl = table(xdata', ydata'); % Convert X and Y into a table, which is the input data form for fitnlm() 
mdl = fitnlm(tbl, yf, B0);
coefficients = mdl.Coefficients.Estimate; 

% A   = 374.2293
% T2* = 51.9163 msec

figure; hold on
plot(xdata, ydata, 'b*', 'LineWidth', 2, 'MarkerSize', 10);
xFit = linspace(min(xdata), max(xdata), 500);
yFitted = coefficients(1) * exp(-xFit./coefficients(2));
plot(xFit, yFitted, 'r-', 'LineWidth', 8);

grid on;
fontSize=20;
title('Regression fitnlm', 'FontSize', fontSize);
xlabel('X', 'FontSize', fontSize);
ylabel('Y', 'FontSize', fontSize);
legendHandle = legend('measured Y', 'Fitted Y fitnlm()', 'Location', 'north');
legendHandle.FontSize = 15;
