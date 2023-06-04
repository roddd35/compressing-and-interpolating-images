function res = generateImage(dim)
    image = zeros(dim, dim, 3);
    x = 45;
    y = 30;
    h = 100;

    for(i = 1: dim)
        for(j = 1: dim)
            image(i, dim + 1 - j, 1) = R(x + (j - 1) * h, y + (i - 1) * h);
            image(i, dim + 1 - j, 2) = G(x + (j - 1) * h, y + (i - 1) * h);
            image(i, dim + 1 - j, 3) = B(x + (j - 1) * h, y + (i - 1) * h);
        endfor
    endfor

    imwrite(image, "generatedImg2.png");
endfunction

function r = R(x, y)
    r = sin(x);
    return;
endfunction

function g = G(x, y)
    g = (tan(y) + sinh(x)) / 2;
    return;
endfunction

function b = B(x, y)
    b = sin(x) * sin(x);
    return;
endfunction