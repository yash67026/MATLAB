f=imread('coins.png'); 
B=[0 1 1;1 1 1;0 1 0]; 
f1=imdilate(f,B); 
se=strel('disk',10); 
f2=imerode(f,se); 
figure,imshow(f) 
title('input image'); 
figure,imshow(f1) 
title('delated image'); 
figure,imshow(f2) 
title('eroded image'); 