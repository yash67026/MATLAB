% Program for edge detection algorithm 
I = imread('yashu3.jpg'); 
figure, imshow(I) 
title('Figure 1: Original Image');

h = ones(5,5) / 25; 
b = imfilter(I, h); 
figure, imshow(b) 
title('Figure 2: Filtered Image');

% Convert to grayscale before edge detection
gray_b = rgb2gray(b);

c = edge(gray_b, 'sobel'); 
figure, imshow(c) 
title('Figure 3: Edge Detected by Sobel Operator');

d = edge(gray_b, 'prewitt'); 
figure, imshow(d) 
title('Figure 4: Edge Detected by Prewitt Operator');

e = edge(gray_b, 'roberts'); 
figure, imshow(e) 
title('Figure 5: Edge Detected by Roberts Operator');

f = edge(gray_b, 'canny'); 
figure, imshow(f) 
title('Figure 6: Edge Detected by Canny Operator');
