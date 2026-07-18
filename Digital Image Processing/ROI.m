% Program for ROI 
clc; 
close all; 
load trees 
I=ind2gray(X,map); 
imshow(I) 
title('original image'); 
I2=roifill; 
imshow(I2) 
title('OUTPUT IMAGE'); 