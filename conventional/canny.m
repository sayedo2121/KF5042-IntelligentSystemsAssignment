%creates a edge map
function canny_img = canny(image)

    %create map using canny with threshold 0.1 and spread 2, as values are
    %1 and 0
    canny_img = uint8(edge(image, "canny", 0.1, 1));
end