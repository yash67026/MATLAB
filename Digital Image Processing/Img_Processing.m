% Program to study the image processing concept 
I=imread('images.jpg'); 
J=imcomplement(I); 
figure,imshow(I) 
figure,imshow(J) 
K=imadjust(I,[0;0.4],[0.5;1]) 
figure,imshow(K)