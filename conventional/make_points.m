function points = make_points(image, avg)
    global g_slope;
    global g_y_int;
    
    try
        slope = avg(1);
        y_int = avg(2);

        g_slope = slope;
        g_y_int = y_int;
    catch ME
        slope = g_slope;
        y_int = g_y_int;
    end

    [y1, ~] = size(image);
    y2 = int16(y1 * (3/5));
    x1 = int16((y1 - y_int) / slope);
    x2 = int16((y2 - y_int) / slope);

    points = [x1 y1 x2 y2];

end