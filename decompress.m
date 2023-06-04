function decompress(compressedImg, method, k, h)
    [img1, map1] = imread(compressedImg);
    [img2, map2] = rgb2ind(img1);
    image = ind2rgb(img2, map2);

    % getting values
    n = size(image, 1);
    p = n + (n - 1) * k;

    decompressedImg = zeros(p, p, 3);

    % make the image bigger so we can interpolate
    linNova = 1;
    colNova = 1;
    for(i = 1: p)
        if(rem(i, k + 1) == 0)
            for(j = 1: p)
                if(rem(j, k + 1) == 0)
                    decompressedImg(i, j, 1) = image(linNova, colNova, 1);
                    decompressedImg(i, j, 2) = image(linNova, colNova, 2);
                    decompressedImg(i, j, 3) = image(linNova, colNova, 3);
                    colNova = colNova + 1;
                endif
            endfor
            colNova = 1;
            linNova = linNova + 1;
        endif
    endfor

    imwrite(decompressedImg, "decompressed.png");
end