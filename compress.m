function r = compress(originalImg, k)
    image = imread(originalImg); # arquivo da imagem
    p = size(image, 1);  # obter o tamanho (n de pixels) de uma dimensao da imagem pxp

    # queremos manter linhas e colunas tal que i % (k+1) = 0
    for(i = 1: p/2)
        if(rem((k + 1), i) != 0)    # se o modulo for diferente de 0, remover a linha e coluna
            image(i, :) = [];
            image(:, i) = [];
        endif
    endfor
    
    imwrite(image, "compressed.png");
end