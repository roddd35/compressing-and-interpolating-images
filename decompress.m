function decompress(compressedImg, method, k, h)
    img = imread(compressedImg);

    % getting values
    n = size(img, 1);
    p = n + (n - 1) * k;

    

    % idea: make a for loop to increase the lines and a separate one to increase the columns
    for(i = 1: n)
        if(rem(i, 2) == 0)
            newImg(:, i) = img(:, i);
            newImg(i, :) = img(i, :);
        endif
    endfor

    imwrite(img, "decompressed.png");
end