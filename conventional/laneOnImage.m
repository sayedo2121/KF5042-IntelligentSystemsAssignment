clear;clc;

img = imread("original.jpg");

gray_img = gray(img);

white_yellow_img = white_yellow(img, gray_img);

isolated = region(white_yellow_img);

blurred_img = gauss(isolated);

canny_img = canny(blurred_img);

lines = hough_lines(canny_img);

[left_line, right_line] = average(img, lines);

lane_lines = display_lines(img, [left_line; right_line]);

final = lane_lines + (img - 40);

figure
imshow(final);