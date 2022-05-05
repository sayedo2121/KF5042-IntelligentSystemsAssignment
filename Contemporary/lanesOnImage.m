clear;clc;

img = imread("original.jpg");

originalSize = size(img);

resized_img = imresize(img, [80, 160]);

net = load("fullConvLaneNet");

laneMask = zeros(80, 160, 3);
laneMask(:, :, 2) = net.fullConvLaneNet.predict(resized_img);
laneMask(:, :, 2) = laneMask(:, :, 2) .* 255;

resizedLaneMask = imresize(laneMask, [originalSize(1), originalSize(2)]);

figure
imshow(laneMask);

final = uint8(resizedLaneMask) + (img-40);

figure
imshow(final);