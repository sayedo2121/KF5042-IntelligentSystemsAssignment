clear; clc;

net = load("fullConvLaneNet");

vid = VideoReader("solidYellowLeft.mp4");

frames = read(vid, [1, Inf]);

output_frames = uint8(zeros(size(frames)));

for f = 1:vid.NumFrames
    frame = frames(:, :, :, f);

    originalSize = size(frame);
    
    resized_img = imresize(frame, [80, 160]);
    
    laneMask = zeros(80, 160, 3);
    laneMask(:, :, 2) = net.fullConvLaneNet.predict(resized_img);
    laneMask(:, :, 2) = laneMask(:, :, 2) .* 128;

    resizedLaneMask = imresize(laneMask, [originalSize(1), originalSize(2)]);
    
    final = uint8(resizedLaneMask) + (frame-40);

    output_frames(:, :, :, f) = final;
end

output_vid = VideoWriter("videoWithLanesYellowLeft.avi", 'Motion JPEG AVI');

open(output_vid);

writeVideo(output_vid, output_frames);

close(output_vid);