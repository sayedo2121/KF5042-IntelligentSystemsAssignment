function mask_yw_image = white_yellow(image, gray)

    img_hsv = rgb2hsv(image);

    lower_yellow = [20 100 100];
    upper_yellow = [30 255 255];

    mask_yellow = true(size(img_hsv,1), size(img_hsv,2));
    for p = 1 : 3
        mask_yellow = mask_yellow & (img_hsv(:,:,p) >= lower_yellow(p) & img_hsv(:,:,p) <= upper_yellow(p));
    end

    mask_white = (gray >= 200 & gray <= 255);

    mask_yw = mask_white | mask_yellow;

    mask_yw_image = uint8(mask_yw & gray);
    
end