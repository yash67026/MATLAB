% Program of sharpen image using gradient mask 
I=imread('coins.png'); 
subplot(2,2,1); 
imshow(I) 
title('Original Image'); 
h=fspecial('sobel'); 
f=imfilter(I,h,'replicate'); 
subplot(2,2,2); 
imshow(F) 
title('filtered image by sobel mask'); 
s=I+F; 
subplot(2,2,4); 
imshow(s) 
title('Final o/p Image'); 
