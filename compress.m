function r = compress(originalImg, k)
tic
    [img1, map1] = imread(originalImg);
    [img2, map2] = rgb2ind(img1);
    image = ind2rgb(img2, map2); 


    p = size(image, 1);  % get the image pixels on one dimension
    n = floor((p + k) / (1 + k));
    compressedImage = zeros(n, n, 3);
    
    linNova = 1;
    colNova = 1;
    for(i = 1: p)
        if(rem(i, k + 1) == 0)
            for(j = 1: p)
                if(rem(j, k + 1) == 0)
                    compressedImage(linNova, colNova, :) = image(i, j, :);
                    colNova = colNova + 1;    % column on the new image only adds when it passes the condition
                endif
            endfor
            colNova = 1;
            linNova = linNova + 1;    % row on the new image only adds when it passes the condition
        endif
    endfor

    imwrite(compressedImage, "compressed.png");
    toc
    return;
end