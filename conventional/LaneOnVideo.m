clear; clc;

%point to a video location
vid = VideoReader("otherFootage/challenge.mp4");

%read all frames
frames = read(vid, [1, Inf]);

%initialise output matrix with same size
output_frames = uint8(zeros(size(frames)));

%loop over frames
for f = 1:vid.NumFrames
    
    %get this frame
    img = frames(:, :, :, f);
    
    %convert to grayscale
    gray_img = gray(img);
    
    %create a binary mask of white and yellow areas
    white_yellow_img = white_yellow(img, gray_img);
    
    %apply guassian filter
    blurred_img = gauss(white_yellow_img);
    
    %create edge map using canny
    canny_img = canny(blurred_img);
    
    %create a region of interest: only keep pixels in lane area
    isolated = region(canny_img);
    
    %detect lines out of edges using hough
    lines = hough_lines(isolated);
    
    %average detected lines and get their params
    [left_line, right_line] = average(img, lines);
    
    %create an RGB image with green lane lines
    lane_lines = display_lines(img, [left_line; right_line]);
    
    %merge with original while reducing its brightness by 40
    final = lane_lines + (img - 40);
    
    %save final frame in output matrix
    output_frames(:, :, :, f) = final;
    
end

%point video writer to location
output_vid = VideoWriter("outputFootage/challenge.avi", 'Motion JPEG AVI');

%open .avi file
open(output_vid);

%write output matix
writeVideo(output_vid, output_frames);

%close file
close(output_vid);
