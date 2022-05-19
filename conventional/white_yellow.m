%creates a binary mask of yellow and white areas
function mask_yw_image = white_yellow(image, gray)

    %convert RGB to HSV coloir space for better yellow representation
    img_hsv = rgb2hsv(image);
    
    %set the needed yellow colour space thresholds
    lower_yellow = [20 100 100];
    upper_yellow = [30 255 255];
    
    %create a true map with 1 in yellow areas
    mask_yellow = true(size(img_hsv,1), size(img_hsv,2));
    for p = 1 : 3
        mask_yellow = mask_yellow & (img_hsv(:,:,p) >= lower_yellow(p) & img_hsv(:,:,p) <= upper_yellow(p));
    end
    
    %create a true map for white values between 200 and 255 from gray
    mask_white = (gray >= 200 & gray <= 255);

    %merge the two masks into one
    mask_yw = mask_white | mask_yellow;

    %keep pixels that only exist in both images
    mask_yw_image = uint8(mask_yw & gray);
    
end