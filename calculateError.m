function r = calculateError(originalImg, decompressedImg)
    imgOG = im2double(imread(originalImg));
    imgDC = im2double(imread(decompressedImg));

    errR = errG = errB = 0;

    p = size(imgDC);

    % % calculate the error in each color
    for(i = 1: p(1))
        for(j = 1: p(2))
            errR = errR + (imgOG(i, j, 1) - imgDC(i, j, 1))^2;
            errG = errG + (imgOG(i, j, 2) - imgDC(i, j, 2))^2;
            errB = errB + (imgOG(i, j, 3) - imgDC(i, j, 3))^2;
        endfor
    endfor

    errR = sqrt(errR/p(1)^2);
    errG = sqrt(errG/p(1)^2);
    errB = sqrt(errB/p(1)^2);

    r = (errR + errG + errB) / 3;
    disp(r);
end