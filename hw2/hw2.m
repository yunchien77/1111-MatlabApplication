close all
clear all

matrix_size=96;
slicenumber=13;

%%%%% start, open open_DWI_BRIK() %%%%%
[image_b0, image_b1000, image_b2000]=open_DWI_BRIK(matrix_size,slicenumber);
%%%%% end, open open_DWI_BRIK() %%%%% 

roi_vol=zeros(matrix_size,matrix_size,slicenumber);  %預留空間(三維矩陣)，針對大腦影像中要取的區域(無意義或黑白者不要看)
                                                     %有意義者(所取範圍內)為!，無意義者(範圍以外)為0

for szz=10:10
 image_b0(:,:,szz)=image_b0(:,:,szz)';
 image_b1000(:,:,szz)=image_b1000(:,:,szz)';
 image_b2000(:,:,szz)=image_b2000(:,:,szz)';
 imagesc(image_b0(:,:,szz));axis('image');colormap(gray(256));
 title(strcat('please draw whole brain ROI on',' slice=',int2str(szz))) 
 roi_vol(:,:,szz)=roipoly;
 close
end

for szz=10:10
imagesc(roi_vol(:,:,szz));axis('image');colormap(gray(256));
 title(strcat('show roi result',' slice=',int2str(szz))) 
 pause;
 close
end

ADC_map=zeros(matrix_size,matrix_size,slicenumber);   %預留空間
Kurtosis_map=zeros(matrix_size,matrix_size,slicenumber);

DK0=[0.002 0.5];
lb=[0];ub=[10000000];
xdata=[0 1000 2000];

for zz=10:10   %第十張slice
 h = waitbar(0,strcat('Please wait for the slice',num2str(zz)));
  for jj=1:matrix_size
  for ii=1:matrix_size
   waitbar(ii/matrix_size)
     if roi_vol(ii,jj,zz)==1    %在所圈範圍內
       S0=image_b0(ii,jj,zz);
       S1000=image_b1000(ii,jj,zz);
       S2000=image_b2000(ii,jj,zz);
       ydata=[log(S0/S0) log(S1000/S0) log(S2000/S0)];

       DK=(lsqcurvefit(@fun_lsqcurfit_ADC_Kurtosis,DK0,xdata,ydata,lb,ub)); 
       ADC_map(ii,jj,zz)=DK(1);
       Kurtosis_map(ii,jj,zz)=DK(2);
     end
   end
   end 
  close(h)
end

clims=[0 25e-4];
for szz=10:10
imagesc(ADC_map(:,:,szz),clims);axis('image');colormap(gray(256));
 title(strcat('ADC map',' slice=',int2str(szz))) 
 pause;
 close
end

clims=[0 2.5];
for szz=10:10
imagesc(Kurtosis_map(:,:,szz),clims);axis('image');colormap(gray(256));
 title(strcat('Kurtosis map',' slice=',int2str(szz))) 
 pause;
 close
end

