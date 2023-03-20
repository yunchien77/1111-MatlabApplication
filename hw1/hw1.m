load MRS_FID.mat;

xx = real(MRS_FID) + i .*imag(MRS_FID); % xx=MRS_FID, 2048x17
[nr, num_cols] = size(xx);
exp_Hz = 30; %Exponential apodization value in Hz unit (0.5 is recommended for in vivo data)
dwell_time=4.0000e-04;%the time between 2 points of the FID.
new_num_rows=nr*2;
BW=2500;
ppm_Hz=123.2624; %% 123.2624 Hz/ ppm if on resonance freq of water is 123.2624 MHz for 3T at the moment of MRS data acqusition
ctr_ppm=4.68; %% water resonance freq=4.68 ppm

xf_apd_5=zeros(nr,num_cols);
xf_apd_8=zeros(nr,num_cols);
xf_zf_5=zeros(new_num_rows,num_cols);
xf_zf_8=zeros(new_num_rows,num_cols);
xf_apd_zf_5=zeros(new_num_rows,num_cols);
xf_apd_zf_8=zeros(new_num_rows,num_cols);

%%% print original data(fifth & eighth) %%%
x_5 = xx(:, 5);
x_8 = xx(:, 8);

figure(1);
plot(abs(x_5), 'r');
hold on;
plot(abs(x_8), 'b');
legend('fifth sampling data', 'eighth sampling data');
title('question 1')


%%% mean(fifth & eighth data) %%%
new_data = mean((x_5 + x_8)/2, 2);
figure(2);
plot(fftshift(abs(fft(new_data))), 'g');
title('question 2')


%% start, apodization %%
num_rows = length(x_5) % = length(x_8)
T2 = 1/(pi*exp_Hz);
tp=0:(num_rows-1);
tp=tp.*dwell_time;
filter_func = exp(-tp./T2);
filter_func=filter_func';

%%% (fifth data) %%%
x_apd_5 = x_5 .* filter_func;

%%% (eighth data) %%%
x_apd_8 = x_8 .* filter_func;

figure(3);
plot(abs(x_apd_5),'r');
hold on;
plot(abs(x_apd_8),'b');
legend('fifth data after apodization','eighth data after apodization');
title('question 3');
%% end, apodization %%


%% start, zerofilling %%
%%% (fifth data) %%%
x_zf_5 = [x_5; zeros(new_num_rows-num_rows, 1)];

%%% (eighth data) %%%
x_zf_8 = [x_8; zeros(new_num_rows-num_rows, 1)];

figure(4);
plot(abs(x_zf_5), 'r');
hold on;
plot(abs(x_zf_8), 'b');
legend('fifth data after zerofilling', 'eighth data after zerofilling');
title('guestion 4');
%% end, zerofilling %5


%% apodization & zerofilling %%
%%% (fifth data) %%%
x_apd_zf_5 = [x_apd_5; zeros(new_num_rows-num_rows, 1)];

%%% (eighth data) %%%
x_apd_zf_8 = [x_apd_8; zeros(new_num_rows-num_rows, 1)];

mean_apd_zf = mean((x_apd_zf_5 + x_apd_zf_8)/2, 2); %mean
xf_apd_zf_single = fftshift(fft(mean_apd_zf));  %fft

figure(5);
plot(abs(xf_apd_zf_single),'g');
legend('after apodization and zerofilling with fft shift');
title('question 5');
%% end %%