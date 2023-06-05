function decompress(compressedImg, method, k, h)
    [img1, map1] = imread(compressedImg);
    [img2, map2] = rgb2ind(img1);
    image = ind2rgb(img2, map2);

    % getting values
    n = size(image, 1);
    p = n + (n - 1) * k;

    decompressedImg = zeros(p, p, 3);

    % BILINEAR
    if(method == 1)
        % make the image bigger so we can interpolate
        decompressedImg(1:k+1:end, 1:k+1:end, :) = image(:, :, :);
        decompressedImg = bilinear(decompressedImg, k, h);
        imwrite(decompressedImg, "bilinear_dec.png");
    endif

    % BICUBIC
    if(method == 2)
        imgR = image(:, :, 1);
        imgG = image(:, :, 2);
        imgB = image(:, :, 3);
        imgR = bicubic(imgR, k, h);
        imgG = bicubic(imgG, k, h);
        imgB = bicubic(imgB, k, h);
        decompressedImg = cat(3, imgR, imgG, imgB);

        imwrite(decompressedImg, "bicubic_dec.png");
    endif
end

% function to calculate the bilinear interpolation
function bl = bilinear(img, k, h)
    i = 1;
    j = 1;
    while(i <= rows(img) - k - 1)
        while(j <= columns(img) - k - 1)
            % initial positions for the matrix
            x_1 = i;
            x_2 = i + k + 1;
            y_1 = j + k + 1;
            y_2 = j;

            % equivalent positions on the rows
            x_1_r = (x_1 - 1) * h;
            x_2_r = (x_2 - 1) * h;
            y_1_r = (y_1 - 1) * h;
            y_2_r = (y_2 - 1) * h;

            % defining the matrix asked
            xyMatrix = [1, x_1_r, y_1_r, x_1_r*y_1_r;...
                        1, x_1_r, y_2_r, x_1_r*y_2_r;...
                        1, x_2_r, y_1_r, x_2_r*y_1_r;...
                        1, x_2_r, y_2_r, x_2_r*y_2_r];

            fQR_Matrix = [img(x_1, y_1, 1);...
                          img(x_1, y_2, 1);...
                          img(x_2, y_1, 1);...
                          img(x_2, y_2, 1)];

            fQG_Matrix = [img(x_1, y_1, 2);...
                          img(x_1, y_2, 2);...
                          img(x_2, y_1, 2);...
                          img(x_2, y_2, 2)];
        
            fQB_Matrix = [img(x_1, y_1, 3);...
                          img(x_1, y_2, 3);...
                          img(x_2, y_1, 3);...
                          img(x_2, y_2, 3)];

            % solving the linear system
            aR = inv(xyMatrix) * fQR_Matrix;
            aG = inv(xyMatrix) * fQG_Matrix;
            aB = inv(xyMatrix) * fQB_Matrix;

            for(z = i: i + k + 1)
                for(w = j: j + k + 1)
                    if(img(z,w,1) == 0)
                        img(z,w,1) = bilinearPolynomium(aR, (z-1)*h, (w-1)*h);
                    endif

                    if(img(z,w,2) == 0)
                        img(z,w,2) = bilinearPolynomium(aG, (z-1)*h, (w-1)*h);
                    endif

                    if(img(z,w,3) == 0)
                        img(z,w,3) = bilinearPolynomium(aB, (z-1)*h, (w-1)*h);
                    endif
                endfor
            endfor
            j = j + k + 1;
        endwhile
        j = 1;
        i = i + k + 1;
    endwhile

    bl = img;
    return;
endfunction

function bc = bicubic (img, k, h)

    Mat = [ 1  0   0     0
            1  h   h.^2  h.^3
            0  1   0     0
            0  1   2*h   3*h.^2]; 
  
    % make the image bigger so we can interpolate
    compressedImage = zeros (columns(img) + (k * (columns(img) - 1)));   
    compressedImage (1: k + 1: end, 1: k+1: end) = img(:, :);  
    
    indOutI = 1;
    for i = 1: rows(img) - 1
        indOutJ = 1;
        for j = 1: columns(img) - 1
            new = getSquare(i, j);
            compressedImage (indOutI: indOutI + k, indOutJ: indOutJ + k) = new(:, :);
            indOutJ += k + 1;
        endfor
        indOutI += k + 1;
    endfor
    
    function sqr = getSquare (i, j)
        coef = getCoef(i,j);
        
        xi = img(i,j);
        yj = img(i,j);
        
        p = 0: k;
        
        xp = xi + p * (h / (k+1));
        yp = yj + p * (h / (k+1));

        sqr = [];
        for (f = 1: k + 1)
            line = [];
            for (ff = 1: k + 1)
                line = [line P(xi, yj, coef, xp(f), yp(ff))];
            endfor
            sqr = [sqr; line];
        endfor
        return;
    endfunction
    
    % defining the polynomium
    function px = P(xi, yj, coef, x,y)
        px = [1 (x-xi) (x-xi).^2 (x-xi).^3];
        px = double(px) * coef;
        px = px * double ([1; (y-yj); (y-yj).^2; (y-yj).^3]);
        return;
    endfunction
        
    function coef = getCoef (i, j)
        f = [ img(i,j)     img(i,j+1)     dfy(i,j)     dfy(i,j+1)
              img(i+1,j)   img(i+1,j+1)   dfy(i+1,j)   dfy(i+1,j+1)
              dfx(i,j)     dfx(i,j+1)     dfxy(i,j)    dfxy(i,j+1)
              dfx(i+1,j)   dfx(i+1,j+1)   dfxy(i+1,j)  dfxy(i+1,j+1)];

        f = double(f);
        coef = inv(Mat) * f * inv(Mat');
        return;
    endfunction  
    
    % calculating the partial derivatives
    function d = dfx (i, j)
        if (i != 1 && i != rows(img))
            d = (img(i + 1, j) - img(i - 1, j)) / (2 * h);
        elseif (i != 1)
            d = (img(i, j) - img(i - 1, j)) / (2 * h);
        else
            d = (img(i + 1, j) - img(i, j)) / (2 * h);
        endif
        return;
    endfunction

    function d = dfy (i, j)        
        if (j != 1 && j != columns(img))
            d = (img(i,j+1) - img(i,j-1)) / (2*h);
        elseif (j != 1)
            d = (img(i,j) - img(i,j-1)) / (2*h);
        else
            d = (img(i,j+1) - img(i,j)) / (2*h);
        endif
        return;
    endfunction

    function d = dfxy (i, j)
        if (i != 1 && i != rows(img))
            d = (dfy(i + 1, j) - dfy(i - 1,j)) / (2 * h);
        elseif (i != 1)
            d = (dfy(i, j) - dfy(i - 1, j)) / (2 * h);
        else
            d = (dfy(i + 1, j) - dfy(i, j)) / (2 * h);
        endif
        return;
    endfunction

    bc = compressedImage;
    return;  
endfunction

function b = bilinearPolynomium(a, x, y)
    b = a(1,1) + a(2,1) * x + a(3, 1) * y + a(4, 1) * x * y;
    return;
endfunction