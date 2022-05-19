%creates a RGB image with green lanes
function lines_image = display_lines(image, lines)
    
    %get image size
    [height, width, ~] = size(image);
    
    %get number of lines: not always 2
    [lines_count, ~] = size(lines);
    
    %initialise output with same size
    lines_image = uint8(zeros(height, width));
    
    %loop over lines
    for i = 1:lines_count
        
        %get the points and create a line image with 10 width for each
        coordinates = lines(i,:);
        lines_image = insertShape(lines_image, "Line", coordinates, "Color", "green", "LineWidth", 10);
    end
end