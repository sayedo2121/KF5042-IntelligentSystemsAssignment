%detects lines form edge map
function lines = hough_lines(image)
    
    %converts pixels and their possible lines to hough space
    [H, T, R] = hough(image);
    
    %gets the highest 5 intersection bins (5 lines)
    P = houghpeaks(H, 5 , "threshold", 0);
    
    %get the coordinates and parameters of the  lines
    lines = houghlines(image, T, R, P, "MinLength", 5, "FillGap", 5);

end