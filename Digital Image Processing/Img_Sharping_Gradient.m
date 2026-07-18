clc; 
clear all; 
close all; 
m=input('Enter the basis matrix dimension: '); 
% Request user input 
n=m; 
alpha2=ones(1,n)*sqrt(2/n); 
alpha2(1)=sqrt(1/n); 
alpha1=ones(1,m)*sqrt(2/m); 
alpha(1)=sqrt(1/m); % square root. 
for u=0:m-1 
for v=0:n-1 
for x=0:m-1 
for y=0:n-1 
a{u+1,v+1}(x+1,y+1)=alpha1(u+1)*alpha2(v+1)*... 
cos((2*x+1)*u*pi/(2*n))*cos((2*y+1)*v*pi/(2*n)); 
end 
end 
end 
end 
mag=a; 
figure(3) % Create figure graphics object 
k=1; 
% Code to plot the basis 
for i=1:m 
for j=1:n 
subplot(m,n,k) 
imshow(mag{i,j},256) 
k=k+1; 
end 
end 
Enter the basis matrix dimension: 5