function r = compress(originalImg, k)
    img1 = imread(originalImg);
    [img2, map2] = rgb2ind(img1);
    image = ind2rgb(img2, map2); 


    p = size(image, 1);  % get the image pixels on one dimension
    n = floor((p + k) / (1 + k));
    compressedImage = ones(n, n, 3);
    
    linNova = 1;
    colNova = 1;
    for(i = 1: p)
        if(rem(i, k+1) == 0)
            for(j = 1: p)
                if(rem(j, k+1) == 0)
                    compressedImage(linNova, colNova, 1) = image(i, j, 1);
                    compressedImage(linNova, colNova, 2) = image(i, j, 2);
                    compressedImage(linNova, colNova, 3) = image(i, j, 3);
                    colNova = colNova + 1;    % column on the new image only adds when it passes the condition
                endif
            endfor
            colNova = 1;
            linNova = linNova + 1;    % row on the new image only adds when it passes the condition
        endif
    endfor

    s = size(compressedImage, 1)
    imwrite(compressedImage, "compressed.png");
    return;
end