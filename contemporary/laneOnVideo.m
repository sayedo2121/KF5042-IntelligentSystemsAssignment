clear; clc;

%load trained network
net = load("fullConvTULaneNet");

%point to a video in storage
vid = VideoReader("otherFootage/solidWhiteRight.mp4");

%read all video frames
frames = read(vid, [1, Inf]);

%get one video frame
sample = frames(:,:,:,1);

%create an output matrix with the same size as sample
output_frames = uint8(zeros(size(sample)));

%loop over all frames
for f = 1: vid.NumFrames
    
    %get frame f
    frame = frames(:, :, :, f);

    %get size of frame f
    originalSize = size(frame);
    
    %resize frame to model's input size and remove other channels
    resized_img = imresize(frame, [288 512]);
    gray_img = im2gray(resized_img);
    
    %create an RGB output matrix with same size
    laneMask = zeros(size(resized_img));

    %predict the segmentation map
    C = semanticseg(gray_img, net.fullConvLaneNet);

    %assign the segmentation map to the green channel of laneMask
    laneMask(:, :, 2) = uint8(C);

    %multiply each pixel by 255 to make lanes visible
    laneMask(:, :, 2) = (laneMask(:, :, 2) - 1).* 255;
    
    %resize output to original size
    resizedLaneMask = imresize(laneMask, [originalSize(1), originalSize(2)]);
    
    %merge both frames while reducing the original's brightness by 40
    final = uint8(resizedLaneMask) + (frame-40);
    
    %save final to output matrix
    output_frames(:, :, :, f) = final;
end

%initialise a videowriter with write location
output_vid = VideoWriter("outputFootage/solidWhiteRightWithLanes.avi", 'Motion JPEG AVI');

%open .avi file
open(output_vid);

%write the output matrix fully
writeVideo(output_vid, output_frames);

%close file
close(output_vid);