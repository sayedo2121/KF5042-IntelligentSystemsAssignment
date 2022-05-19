%creates two lines from detected hough lines
function [left_line, right_line] = average(image, lines)
    
    %initialise array to distribute lines
    left = [];
    right = [];
    
    %loop over all lines
    for i = 1:length(lines)

        %get the start and end of line
        x1 = lines(i).point1(1);
        y1 = lines(i).point1(2);
        x2 = lines(i).point2(1);
        y2 = lines(i).point2(2);

        %create linear equation from two points
        parameters = polyfit([x1, x2], [y1, y2], 1);
        
        %get slope and y intersect of equation
        slope = parameters(1);
        y_int = parameters(2);
        
        %classify lines as left or right based on slope polarity (inversed)
        if slope < 0
            left = [left; slope, y_int];
        else
            right = [right; slope, y_int];
        end
    end
    
        %average out lines to get one each
        right_avg = mean(right);
        left_avg = mean(left);
        
        %make points out of average lines to make lane mask
        left_line = make_points(image, left_avg);
        right_line = make_points(image, right_avg);

end