f=imread('coins.png'); 
se=strel('square',20); 
fo=imopen(f,se); 
figure,imshow(f) 
title('input image'); 
figure,imshow(fo) 
title('opening of input image'); 
fc=imclose(f,se); 
figure,imshow(fc) 
title('opening of input image'); 
foc=imclose(fo,se); 
figure,imshow(foc) 
title('closing of opened input image'); 