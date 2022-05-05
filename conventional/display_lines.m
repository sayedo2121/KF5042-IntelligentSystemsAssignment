function lines_image = display_lines(image, lines)
    
    [height, width, ~] = size(image);

    [lines_count, ~] = size(lines);

    lines_image = uint8(zeros(height, width));
    
    for i = 1:lines_count

        coordinates = lines(i,:);
        lines_image = insertShape(lines_image, "Line", coordinates, "Color", "green", "LineWidth", 10);
    end
end