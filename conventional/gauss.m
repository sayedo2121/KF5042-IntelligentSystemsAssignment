%applies gaussian filter
function guass_img = gauss(image)
    
    %apply gaussain filter with a spread of 2
    guass_img = imgaussfilt(image, 2);

end