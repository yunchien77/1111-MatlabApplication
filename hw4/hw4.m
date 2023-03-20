clear all
close all

load("HW_x_Data.mat"); %臨床病人的疾病診斷期別(stages 1,2,3,4,5)  %input data
load("HW_Data.mat");   %這些病人所測量出來的大腦功能分數           %target data(labeled output)

xx = HW_x_Data;
yy = HW_Data;

netconf = [20];
net = feedforwardnet(netconf); %feedforwardnet creates a two-layer feed-forward network. The network has one hidden layer with ten neurons.
net = train(net,xx,yy);
yypred = net(xx);
perf = perform(net,yy,yypred)
%err=mean((yypred-yy).^2);

figure;hold on
plot(xx, yy,':r*');
plot(xx, yypred,'-bo');
legend('target', 'predicted by network')