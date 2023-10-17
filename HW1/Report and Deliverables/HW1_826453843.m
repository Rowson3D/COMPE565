% compE565 Homework 1 
% Sept. 23, 2023
% Name: Jarrod Rowson 
% ID: 826453843 
% email: jrowson7843@sdsu.edu  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Problem 1: Basic Image Processing
% M-file name: hw1_processing.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% task 1: read and display the image using MATLAB
dir = 'Requirements/';
i = imread([dir 'Waterfall.jpg'], 'jpg');
imshow(i);
title('original image')

% Reporting: Display a message about image loading
disp('Task 1: Image loaded and displayed.');

% task 2: display each band (red, green, and blue) of the image file
r = i;
r(:,:,2:3) = 0;

g = i;
g(:,:,[1 3]) = 0;

b = i;
b(:,:,1:2) = 0;

% the three RGB images
rgb1 = cat(3,r(:,:,1),g(:,:,2),b(:,:,3));

figure;
subplot(1, 3, 1), imshow(r), title('red band');
subplot(1, 3, 2), imshow(g), title('green band');
subplot(1, 3, 3), imshow(b), title('blue band');

% Reporting: Display a message about displaying RGB bands
disp('Task 2: Displayed the red, green, and blue bands.');

% task 3: convert the image into YCbCr color space
ycbcr = rgb2ycbcr(i);

% task 4: display each band separately (Y, Cb, and Cr bands)
y = ycbcr(:, :, 1);
cb = ycbcr(:, :, 2);
cr = ycbcr(:, :, 3);

figure;
subplot(1, 3, 1), imshow(y), title('Y band');
subplot(1, 3, 2), imshow(cb), title('Cb band');
subplot(1, 3, 3), imshow(cr), title('Cr band');

% Reporting: Display a message about displaying YCbCr bands
disp('Task 4: Displayed the Y, Cb, and Cr bands.');

% task 5: subsample Cb and Cr bands using 4:2:0 and display both bands
cbSubsampled = imresize(cb, 0.5, 'bilinear'); % bilinear will be used for the interpolation method
crSubsampled = imresize(cr, 0.5, 'bilinear');

figure;
subplot(1, 2, 1), imshow(cbSubsampled), title('subsampled Cb band');
subplot(1, 2, 2), imshow(crSubsampled), title('subsampled Cr band');

% Reporting: Display a message about subsampling
disp('Task 5: Subsampled the Cb and Cr bands.');

% task 6: upsample and display the Cb and Cr bands using simple row and column replication
cbUpsampled = imresize(cbSubsampled, 2, 'nearest'); % nearest will be used for replication
crUpsampled = imresize(crSubsampled, 2, 'nearest');

figure;
subplot(1, 2, 1), imshow(cbUpsampled), title('upsampled Cb band');
subplot(1, 2, 2), imshow(crUpsampled), title('upsampled Cr band');

% Reporting: Display a message about upsampling
disp('Task 6: Upsampled the Cb and Cr bands.');

% task 7: convert the image into RGB format
rgb = ycbcr2rgb(ycbcr);

% task 8: display the original and reconstructed images
figure;
subplot(1, 2, 1), imshow(i), title('original RGB image');
subplot(1, 2, 2), imshow(rgb), title('reconstructed RGB image');

% Reporting: Display a message about image conversion and display
disp('Task 7 and 8: Converted the image to RGB and displayed the original and reconstructed images.');

% task 9: comment on the visual quality of the reconstructed image for both upsampling cases
% you can visually assess the quality and discuss any differences

% Reporting: Display a message about visual quality assessment
disp('Task 9: Please visually assess the quality of the reconstructed images.');

% task 10: measure MSE between the original and reconstructed images
mse = immse(i, rgb);

% Reporting: Display MSE information in a table
disp('Task 10: Mean squared error (MSE) between original and reconstructed images:');
MSE_Data = {'MSE Value', mse};
disp(MSE_Data);

% task 11: comment on the compression ratio achieved by subsampling Cb and Cr components for 4:2:0 approach
% calculate and discuss the compression ratio achieved by the 4:2:0 subsampling approach

% Calculate the compression ratio
originalSize = numel(cb);
subsampledSize = numel(cbSubsampled);
compressionRatio = originalSize / subsampledSize;

% Reporting: Display a message about compression ratio
disp('Task 11: Calculated and discussed the compression ratio achieved by the 4:2:0 subsampling approach.');
Compression_Data = {'Compression Ratio', compressionRatio};
disp(Compression_Data);

% end of the code
