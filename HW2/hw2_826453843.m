
% File: HW2_826453843.m
% Date: 10/16/2023
% Email: jrowson7843@sdsu.edu


clear all;
clc;

% Encoder part:
% Q1: 2D-DCT transfrom

% Read the image
img = imread('waterfall.jpg','jpg');
% Convert to YCbCr
ycbcr = rgb2ycbcr(img);

figure(1)
subplot(2,2,1), subimage(img), title("Original RGB")
subplot(2,2,2), subimage(ycbcr), title("YCbCr")

% Downsize the chrominance by 4:2:0
y_comp  = ycbcr(:,:,1);
cb_comp = ycbcr(:,:,2);
cr_comp = ycbcr(:,:,3);

total_rows = size(ycbcr,1);
total_cols = size(ycbcr,2);

fprintf("Total rows before downsampling = %d\n", total_rows);
fprintf("Total cols before downsampling = %d\n", total_cols);

cb_copy = cb_comp;
cr_copy = cr_comp;

% Make all chrominance components zero!!
for row = 2:2:total_rows
    for col = 2:2:total_cols
        cb_copy(row,col) = 0;
        cr_copy(row,col) = 0;
    end
end

% Remove the unwanted values from the chrominance components
cb_420 = cb_copy(1:2:end,1:2:end);
cr_420 = cr_copy(1:2:end,1:2:end);

figure(2)
subplot(2,2,1), subimage(cb_comp), title("Original cb")
subplot(2,2,2), subimage(cr_comp), title("Original cr")
subplot(2,2,3), subimage(cb_420), title("Cb 4:2:0")
subplot(2,2,4), subimage(cr_420), title("Cr 4:2:0")

row_cb_420 = size(cb_420,1);
col_cb_420 = size(cb_420,2);

row_cr_420 = size(cr_420,1);
col_cr_420 = size(cr_420,2);
fprintf("Total rows in 4:2:0 cb comp. = %d\nTotal rows in 4:2:0 cb comp. = %d\n", row_cb_420, col_cb_420);
fprintf("Total rows in 4:2:0 cr comp. = %d\nTotal rows in 4:2:0 cr comp. = %d\n", row_cr_420, col_cr_420);

% Taking out 1st 8x8 block from the luminance comp.
% Making a copy of y comp
y_cpy = y_comp;

% Block processing with 2D DCT transform
% Since dct2 function accepts matrix only as input, need to make the
% blockproc function return an appropriate size so double data type.

%dct_handle = @(block_struct)dct2(block_struct.data);
dct_handle = @dct2;
% Now 8x8 block processing on y_cpy
y_dct = blkproc(y_cpy,[8 8],dct_handle);

% Now computing the DC coefficients for the cb and cr components
cb_cpy = cb_420;
cr_cpy = cr_420;

cb_dct = blkproc(cb_cpy,[8 8],dct_handle);
cr_dct = blkproc(cr_cpy,[8 8],dct_handle);

figure(3)
subplot(2,2,1), subimage(y_dct), title("2D DCT Y comp")
subplot(2,2,2), subimage(cb_dct), title("2D DCT Cb comp")
subplot(2,2,3), subimage(cr_dct), title("2D DCT Cr comp")

% Now taking out the 1st 2 blocks from the 6th row DCT
y_dct_block1 = y_dct(41:48,1:8);
y_dct_block2 = y_dct(41:48,9:16);

% Displaying the DCT coefficients of luminance blocks
fprintf("\nThe 2D-DCT coefficients of 1st block:\n")
disp(y_dct_block1)
fprintf("\nThe 2D-DCT coefficients of 2nd block:\n")
disp(y_dct_block2)

figure(4)
subplot(2,2,1), subimage(y_dct_block1), title("8x8 Y comp block1")
subplot(2,2,2), subimage(y_dct_block2), title("8x8 Y comp block2")

% Truncating the 8x8 blocks for correct representation using imshow()
% Truncate() defined at the end of this script
t_blk1 = truncate(y_dct_block1);
fprintf("Truncated 8x8 blk1:\n");
disp(t_blk1);
t_blk2 = truncate(y_dct_block2);
fprintf("Truncated 8x8 blk2:\n");
disp(t_blk2);

% Displaying the truncated blocks
figure(5)
subplot(2,2,1), imshow(t_blk1),title("Truncated 8x8 block1")
subplot(2,2,2), imshow(y_dct_block1),title("Original 8x8 block1")
subplot(2,2,3), imshow(t_blk2),title("Truncated 8x8 block2")
subplot(2,2,4), imshow(y_dct_block2),title("Original 8x8 block2")

% Q2: Quantization

% The quantization matrix for luminance from lecture
lum_q_matrix = [16 11 10 16 24 40 51 61;
                12 12 14 19 26 58 60 55;
                14 13 16 24 40 57 69 56;
                14 17 22 29 51 87 89 62;
                18 22 37 56 68 109 103 77;
                24 35 55 64 81 104 113 92;
                49 64 78 87 108 121 120 101;
                72 92 95 98 112 100 103 99];

% The quantization matrix for chrominance from lecture
chr_q_matrix = [17 18 24 47 99 99 99 99;
                18 21 26 66 99 99 99 99;
                24 26 56 99 99 99 99 99;
                47 66 99 99 99 99 99 99;
                 99 99 99 99 99 99 99 99;
                 99 99 99 99 99 99 99 99;
                 99 99 99 99 99 99 99 99;
                 99 99 99 99 99 99 99 99];

% Creating copies of y, cb, and cr dct matrices
y_dct_cpy  = y_dct;
cb_dct_cpy = cb_dct;
cr_dct_cpy = cr_dct;

% Dividing the dct block structure with the lum matrix.
q_lum = @(y_dct_cpy) round(y_dct_cpy./lum_q_matrix);
% 8x8 block processing on the quantized matrix
y_dct_q = blkproc(y_dct_cpy,[8 8],q_lum);

% Dividing the dct block_struct data with the chrominance matrix.
q_chr1 = @(cb_dct_cpy) round(cb_dct_cpy./chr_q_matrix);
q_chr2 = @(cr_dct_cpy) round(cr_dct_cpy./chr_q_matrix);
% 8x8 block processing on the quantized matrix
cb_q_dct = blkproc(cb_dct_cpy,[8 8],q_chr1);
cr_q_dct = blkproc(cr_dct_cpy,[8 8],q_chr2);

% Reporting the data for the first 2 blocks in the 6th row from the top.
q_y_blk1  = y_dct_q(41:48,1:8);
q_y_blk2  = y_dct_q(41:48,9:16);
q_cb_blk1 = cb_q_dct(41:48,1:8);
q_cb_blk2 = cb_q_dct(41:48,9:16);
q_cr_blk1 = cr_q_dct(41:48,1:8);
q_cr_blk2 = cr_q_dct(41:48,9:16);

% Displaying the quantized y, cb, cr blocks
figure(6)
subplot(3,2,1), subimage(q_y_blk1), title("Quantized 1st 8x8 block of Y comp.")
subplot(3,2,2), subimage(q_y_blk2), title("Quantized 2nd 8x8 block of Y comp.")
subplot(3,2,3), subimage(q_cb_blk1), title("Quantized 1st 8x8 block of Cb comp.")
subplot(3,2,4), subimage(q_cb_blk2), title("Quantized 2nd 8x8 block of Cb comp.")
subplot(3,2,5), subimage(q_cr_blk1), title("Quantized 1st 8x8 block of Cr comp.")
subplot(3,2,6), subimage(q_cr_blk2), title("Quantized 2nd 8x8 block of Cr comp.")

% Printing the DC coefficient of the luminance block
fprintf("The DC coefficient for 1st 8x8 block of Y comp: %d\nThe DC coefficient for 2nd 8x8 block of Y comp: %d\n", q_y_blk1(1,1), q_y_blk2(1,1));
fprintf("The 8x8 luminance block1:\n");
disp(q_y_blk1);

% Now Finding the AC coefficient.
% Using the zigzag scanning to find the AC coefficients.
% Zigzag() function defined at the end of this script.
ac_mat1 = zigzag(q_y_blk1);
fprintf("The AC coefficients of luminance component 8x8 blk1:\n");
display(ac_mat1(2:end));
ac_mat2 = zigzag(q_y_blk2);
fprintf("The 8x8 luminance block2:\n");
disp(q_y_blk2);
fprintf("\nThe AC coefficients of luminance component 8x8 blk2:\n");
display(ac_mat2(2:end));

% Decoder Part:
% Q3: Inverse Quantization

% In inverse quantization, we will multiply the quantization lum and chr.
% matrix to the quantized DCT matrices of the lum and chrominance
% components.

% Now multiplying the quantized lum matrix with the quantization matrix for
% inverse DCT operation

y_q_cpy  = y_dct_q;
cb_q_cpy = cb_q_dct;
cr_q_cpy = cr_q_dct;

% Performing the inverse quantization by multiplying the quantization
% matrix to get the inverse quantized matrices
iq_lum = @(y_q_cpy) round(y_q_cpy .* lum_q_matrix);
% 8x8 block processing of the entire matrix
iq_y = blkproc(y_dct_q,[8 8],iq_lum);

% Performing the same operation for cb and cr
iq_chr1 = @(cb_q_cpy) round(cb_q_cpy .* chr_q_matrix);
iq_chr2 = @(cr_q_cpy) round(cr_q_cpy .* chr_q_matrix);

iq_cb = blkproc(cb_q_dct,[8 8],iq_chr1);
iq_cr = blkproc(cr_q_dct,[8 8],iq_chr2);

% Displaying the inverse quantized y, cb, and cr images.
figure(7)
subplot(3,1,1), subimage(iq_y), title("Inverse quantized image of Y comp")
subplot(3,1,2), subimage(iq_cb), title("Inverse quantized image of Cb comp")
subplot(3,1,3), subimage(iq_cr), title("Inverse quantized image of Cr comp")

% Q4 Reconstruct, PSNR, Error Image of Y component

% Now will apply the inverse DCT to Y, Cb, and Cr component matrices
% separately.

idct_handle = @(block_struct) idct2(block_struct.data);
% Using the above handle with the blockproc()
y_idct  = blockproc(iq_y,[8 8],idct_handle);
cb_idct = blockproc(iq_cb,[8 8],idct_handle);
cr_idct = blockproc(iq_cr,[8 8],idct_handle);

% Since ycbcr needs to be in the unsigned int format typecasting the above
% array to uint8

y_idct  = uint8(y_idct);
cb_idct = uint8(cb_idct);
cr_idct = uint8(cr_idct);

% Displaying the inverse DCT Y, Cb, and Cr components
figure(8)
subplot(3,1,1), subimage(y_idct), title("Inverse DCT image of Y comp")
subplot(3,1,2), subimage(cb_idct), title("Inverse DCT image of Cb comp")
subplot(3,1,3), subimage(cr_idct), title("Inverse DCT image of Cr comp")

% Now reconstructing the RGB image from the above idct matrices
% Using linear interpolation method from HW 1
t_r = size(ycbcr,1);
t_c = size(ycbcr,2);
rep_ycbcr = zeros(t_r,t_c,3);
y_idct_cpy = y_idct;
cb_idct_cpy = cb_idct;
cr_idct_cpy = cr_idct;

rep_ycbcr(1:2:t_r,1:2:t_c,2) = cb_idct_cpy(:,:);
rep_ycbcr(1:2:t_r,1:2:t_c,3) = cr_idct_cpy(:,:);
% Temp var to hold upsampled cb and cr values
temp_cb = rep_ycbcr(:,:,2);
temp_cr = rep_ycbcr(:,:,3);

% Performing linear interpolation on cb and cr components for upsampling
if mod(t_r,2) == 0
    for r = 2:2:t_r - 2
        for c = 1:2:t_c
            temp_cb(r,c) = round((temp_cb(r-1,c)+temp_cb(r+1,c))/2);
            temp_cr(r,c) = round((temp_cr(r-1,c)+temp_cr(r+1,c))/2);
        end
    end
    for c = 2:2:t_c - 2
        for r = 1:1:t_r
            temp_cb(r,c) = round((temp_cb(r,c-1)+temp_cb(r,c+1))/2);
            temp_cr(r,c) = round((temp_cr(r,c-1)+temp_cr(r,c+1))/2);
        end
    end
    for r = t_r
        for c = t_c
            temp_cb(r,c) = temp_cb(r-1,c);
            temp_cr(r,c) = temp_cr(r-1,c);
        end
    end
else
    for r = 2:2:t_r - 1
        for c = 1:2:t_c
            temp_cb(r,c) = round((temp_cb(r-1,c)+temp_cb(r+1,c))/2);
            temp_cr(r,c) = round((temp_cr(r-1,c)+temp_cr(r+1,c))/2);
        end
    end
    for c = 2:2:t_c - 1
        for r = 1:2:t_r
            temp_cb(r,c) = round((temp_cb(r,c-1)+temp_cb(r,c+1))/2);
            temp_cr(r,c) = round((temp_cr(r,c-1)+temp_cr(r,c+1))/2);
        end
    end
end

rep_ycbcr = cat(3,y_idct,temp_cb,temp_cr);
% Now converting the reconstructed YCbCr image to RGB
rep_rgb = ycbcr2rgb(rep_ycbcr);

figure(9)
subplot(2,2,1), subimage(ycbcr), title("Original YCbCr Image")
subplot(2,2,2), subimage(rep_ycbcr), title("Reconstructed YCbCr Image")
subplot(2,2,3), subimage(img), title("Original RGB Image")
subplot(2,2,4), subimage(rep_rgb), title("Reconstructed RGB Image")

% Calculating the error in the image only for luminance.
% Subtracting the reconstructed Y comp from the original Y component
error = ycbcr(:,:,1) - rep_ycbcr(:,:,1);
% Displaying the error image
figure(10)
subplot(3,1,1), subimage(ycbcr(:,:,1)), title("Original Y comp.")
subplot(3,1,2), subimage(rep_ycbcr(:,:,1)), title("Reconstructed Y comp.")
subplot(3,1,3), subimage(error), title("Error between Reconstructed and Original Image")

% Calculating the PSNR of the decoded luminance of the image using luminance of
% the original image as reference.
% Using the psnr() MATLAB function to calculate the PSNR value.
psnr_lum = psnr(rep_ycbcr(:,:,1), ycbcr(:,:,1));
fprintf("Peak SNR: %f\n", psnr_lum);

% Defining a function to truncate 8x8 blocks for imshow()
function op = truncate(blk)
    min_v = min(min(blk));
    min_v = -min_v;
    op = blk;
    for i = 1:1:8
        for j = 1:1:8
            if op(i,j) == 0
                op(i,j) = op(i,j);
            else
                op(i,j) = op(i,j) + min_v;
            end
        end
    end
    op = op./255;
end

% Defining the zigzag function at the end of the file
function ac_mat = zigzag(q_blk)
    index = 1;
    mat_dct = q_blk;
    ac_mat = [];
    N = 8;
    for c = 1:2*N-1
        if c <= N
            if mod(c,2) == 0
                j = c;
                for i = 1:c
                    ac_mat(index) = mat_dct(i,j);
                    index = index + 1;
                    j = j - 1;
                end
            else
                i = c;
                for j = 1:c
                    ac_mat(index) = mat_dct(i,j);
                    index = index + 1;
                    i = i - 1;
                end
            end
        else
            if mod(c,2) == 0
                p = mod(c,N);
                j = N;
                for i = p+1:N
                    ac_mat(index) = mat_dct(i,j);
                    index = index + 1;
                    j = j - 1;
                end
            else
                p = mod(c,N);
                i = N;
                for j = p+1:N
                    ac_mat(index) = mat_dct(i,j);
                    index = index + 1;
                    i = i - 1;
                end
            end
        end
    end
end

% Reconstructing the chrominance
function rgb_img = ycbcr2rgb(ycbcr_img)
    Y = ycbcr_img(:,:,1);
    Cb = ycbcr_img(:,:,2);
    Cr = ycbcr_img(:,:,3);

    % Conversion
    R = Y + 1.402 * (Cr - 128);
    G = Y - 0.344136 * (Cb - 128) - 0.714136 * (Cr - 128);
    B = Y + 1.772 * (Cb - 128);

    % Combining the channels
    rgb_img = cat(3, R, G, B);

    % Clipping values to be in the range [0, 255]
    rgb_img = max(0, min(255, rgb_img));
    rgb_img = uint8(rgb_img);
end

