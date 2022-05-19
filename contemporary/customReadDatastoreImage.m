function data = customReadDatastoreImage(filename)
    % code from default function: 
    onState = warning('off', 'backtrace'); 
    c = onCleanup(@() warning(onState)); 
    data = imread(filename); % added lines: 
    data = imresize(data,0.4); %resize to 40%
    data = im2gray(data); %convert to grayscale
end