clear; clc;

vid = VideoReader("solidYellowLeft.mp4");

frames = read(vid, [1, Inf]);

output_frames = uint8(zeros(size(frames)));

for f = 1:vid.NumFrames
    
    img = frames(:, :, :, f);

    gray_img = gray(img);

    white_yellow_img = white_yellow(img, gray_img);
    
    blurred_img = gauss(white_yellow_img);
    
    canny_img = canny(blurred_img);
    
    isolated = region(canny_img);
    
    lines = hough_lines(isolated);
    
    [left_line, right_line] = average(img, lines);
    
    lane_lines = display_lines(img, [left_line; right_line]);
    
    final = lane_lines + (img - 40);

    output_frames(:, :, :, f) = final;
    
end

output_vid = VideoWriter("videoWithLanesYellowLeft.avi", 'Motion JPEG AVI');

open(output_vid);

writeVideo(output_vid, output_frames);

close(output_vid);
