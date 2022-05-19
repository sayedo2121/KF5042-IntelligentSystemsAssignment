%makes points out from averaged line equation
function points = make_points(image, avg)
    global g_slope;
    global g_y_int;
    
    %try and catch when lines do not exist
    try
        %get line params
        slope = avg(1);
        y_int = avg(2);
        
        %set them to global variables to be used when lanes are not
        %detected
        g_slope = slope;
        g_y_int = y_int;

    catch ME

        %use previous ones when lanes are not detected
        slope = g_slope;
        y_int = g_y_int;
    end
    
    %set lines start from bottom to 3/5 from it, and X according to
    %linear equation values based on the selected y values
    [y1, ~] = size(image);
    y2 = int16(y1 * (3/5));
    x1 = int16((y1 - y_int) / slope);
    x2 = int16((y2 - y_int) / slope);
    
    %return points
    points = [x1 y1 x2 y2];

end