function r = calculateError(originalImg, decompressedImg)
    imgOG = imread(originalImg);
    imgDC = imread(decompressedImg);
    
    % separate the original image in RGB tones
    imgOGR = imgOG(:,:,1);
    imgOGG = imgOG(:,:,2);
    imgOGB = imgOG(:,:,3);

    % separate the decompressed image in RGB tones
    imgDCR = imgDC(:,:,1)
    imgDCG = imgDC(:,:,2)
    imgDCB = imgDC(:,:,3)

    % calculate the error in each color
    % it may be necessary to cast convert the values of the images to double
    errR = norm((imgOGR - imgDCR),2) / norm(imgOGR, 2);
    errG = norm((imgOGG - imgDCG),2) / norm(imgOGG, 2);
    errB = norm((imgOGB - imgDCB),2) / norm(imgOGB, 2);

    r = (errR + errG + errB) / 3;
end