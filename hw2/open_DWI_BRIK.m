function [image_b0 image_b1000 image_b2000]=open_DWI_BRIK(matrix_size,slicenumber);

%%%%%%%% open u3-T2WI-anatomy imaging %%%%%%%%
% clear all
% close all

[filename,pathname] = uigetfile();
filename=strcat(pathname,filename);
fid=fopen([filename],'r');
a=fread(fid,'int16');

tempstr=inputdlg('Please input slice number?');
slicenumber=str2num(tempstr{1});
tempstr=inputdlg('Please input Repetition number?');%3*8=24
RepetitionNumber=str2num(tempstr{1});
trueRepeat=floor(RepetitionNumber/3);
img0=reshape(a,[matrix_size matrix_size slicenumber RepetitionNumber]);

image_b0_0=zeros(matrix_size, matrix_size, slicenumber, (trueRepeat)); 
image_b1000_0=zeros(matrix_size, matrix_size, slicenumber, (trueRepeat)); 
image_b2000_0=zeros(matrix_size, matrix_size, slicenumber, (trueRepeat)); 

for ss=1:slicenumber
 for rr=1:trueRepeat
  image_b0_0(:,:,ss,rr)=img0(:,:,ss,3*(rr-1)+1);
  image_b2000_0(:,:,ss,rr)=img0(:,:,ss,3*(rr-1)+2);
  image_b1000_0(:,:,ss,rr)=img0(:,:,ss,3*(rr-1)+3);
 end
end

image_b0=mean(image_b0_0,4);% 96*96*13ªº¯x°}
image_b2000=mean(image_b2000_0,4);
image_b1000=mean(image_b1000_0,4);

% check Data %%%%%%%
for s=1:slicenumber
figure;
clims=[0 5000];
imagesc(image_b2000(:,:,s)',clims);axis image;colormap(gray(256));
title(strcat('Slice=', int2str(s)));colorbar
pause;
close
end

% for s=1:slicenumber
% figure;
% clims=[0 5000];
% imagesc(image_b1000(:,:,7)',clims);axis image;colormap(gray(256));
% title(strcat('Slice=', int2str(s)));colorbar
% end
%%%%%%%%%%%%%%%%%%%

