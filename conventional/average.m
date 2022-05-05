function [left_line, right_line] = average(image, lines)

    left = [];
    right = [];

    for i = 1:length(lines)

        x1 = lines(i).point1(1);
        y1 = lines(i).point1(2);
        x2 = lines(i).point2(1);
        y2 = lines(i).point2(2);

        parameters = polyfit([x1, x2], [y1, y2], 1);

        slope = parameters(1);
        y_int = parameters(2);
        
        if slope < 0
            left = [left; slope, y_int];
        else
            right = [right; slope, y_int];
        end
    end

        right_avg = mean(right);
        left_avg = mean(left);

        left_line = make_points(image, left_avg);
        right_line = make_points(image, right_avg);

end