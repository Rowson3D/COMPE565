% task 1: read and display the image using MATLAB
dir = 'Requirements/';
i = imread([dir 'Waterfall.jpg'], 'jpg');
imshow(i);
title('original image')

% task 2: display each band (red, green, and blue) of the image file

r = i;
r(:,:,2:3) = 0;

g = i;
g(:,:,[1 3]) = 0;

b = i;
b(:,:,1:2) = 0;

% now you have three RGB images called r, g, and b
% you could reassemble them directly:
rgb1 = cat(3,r(:,:,1),g(:,:,2),b(:,:,3));

figure;
subplot(1, 3, 1), imshow(r), title('red band');
subplot(1, 3, 2), imshow(g), title('green band');
subplot(1, 3, 3), imshow(b), title('blue band');

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

% task 5: subsample Cb and Cr bands using 4:2:0 and display both bands
cbSubsampled = imresize(cb, 0.5, 'bilinear'); % bilinear will be used for the interpolation method
crSubsampled = imresize(cr, 0.5, 'bilinear');

figure;
subplot(1, 2, 1), imshow(cbSubsampled), title('subsampled Cb band');
subplot(1, 2, 2), imshow(crSubsampled), title('subsampled Cr band');

% task 6: upsample and display the Cb and Cr bands using simple row and column replication
cbUpsampled = imresize(cbSubsampled, 2, 'nearest'); % nearest will be used for replication
crUpsampled = imresize(crSubsampled, 2, 'nearest');

figure;
subplot(1, 2, 1), imshow(cbUpsampled), title('upsampled Cb band');
subplot(1, 2, 2), imshow(crUpsampled), title('upsampled Cr band');

% task 7: convert the image into RGB format
rgb = ycbcr2rgb(ycbcr);

% task 8: display the original and reconstructed images
figure;
subplot(1, 2, 1), imshow(i), title('original RGB image');
subplot(1, 2, 2), imshow(rgb), title('reconstructed RGB image');

% task 9: comment on the visual quality of the reconstructed image for both upsampling cases
% you can visually assess the quality and discuss any differences

% task 10: measure MSE between the original and reconstructed images
mse = immse(i, rgb);
fprintf('mean squared error (MSE) between original and reconstructed images: %.2f\n', mse);

% task 11: comment on the compression ratio achieved by subsampling Cb and Cr components for 4:2:0 approach
% calculate and discuss the compression ratio achieved by the 4:2:0 subsampling approach

% end of the code
