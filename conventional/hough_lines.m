function lines = hough_lines(image)

    [H, T, R] = hough(image);
    
    P = houghpeaks(H, 5 , "threshold", 0);
    
    lines = houghlines(image, T, R, P, "MinLength", 5, "FillGap", 5);

end