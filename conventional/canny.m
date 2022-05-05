function canny_img = canny(image)

    canny_img = uint8(edge(image, "canny", 0.99));
end