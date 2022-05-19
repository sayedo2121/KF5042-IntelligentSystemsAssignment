clear;clc;

%load image
img = imread("otherFootage/original.jpg");

%make image grayscale
gray_img = gray(img);

%get a mask of white and yellow areas
white_yellow_img = white_yellow(img, gray_img);

%apply region of interest: filter upper half
isolated = region(white_yellow_img);

%apply guassian filter
blurred_img = gauss(isolated);

%get edge map using canny
canny_img = canny(blurred_img);

%detect edge lines using hough transform
lines = hough_lines(canny_img);

%average detected lines to make only two: left and right
[left_line, right_line] = average(img, lines);

%create a green lane image
lane_lines = display_lines(img, [left_line; right_line]);

%merge lanes with original image while reducing the brightness of original
final = lane_lines + (img - 40);

%show final
figure
imshow(final);