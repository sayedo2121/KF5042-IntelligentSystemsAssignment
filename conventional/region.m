function region_img = region(image)

    [height, width] = size(image);

    tip_x = uint16(width * 0.5);
    tip_y = uint16(height * 0.5);

    triangle_x = double([0 tip_x width]);
    triangle_y = double([height tip_y height]);

    mask = poly2mask(triangle_x, triangle_y, height, width);

    region_img = uint8(image & mask);

end