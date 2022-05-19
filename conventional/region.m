%filters out any pixels outside the lane area
function region_img = region(image)
    
    %get size
    [height, width] = size(image);
    
    %create the tip point for the ROI triangle: middle of image
    tip_x = uint16(width * 0.5);
    tip_y = uint16(height * 0.5);
    
    %create triangle height and width: bottom to middle, all, respectively
    triangle_x = double([0 tip_x width]);
    triangle_y = double([height tip_y height]);
    
    %create mask with coordinates
    mask = poly2mask(triangle_x, triangle_y, height, width);
    
    %keep pixels that only match between the two
    region_img = uint8(image & mask);

end