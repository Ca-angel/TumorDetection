clc
close all
clear all
    
%% -- -- %%
entrada = imread('tumor6.jpg');
subplot 331
imshow(entrada)
title('Original')

%% -- -- %%
if size(entrada, 3) == 3
    entrada = rgb2gray(entrada);
end

%% -- Ajuste Intensidad -- %%
imagen_ajust = imadjust(entrada,[35 /255 245/255],[0/255 255/255]); 
subplot 332
imshow(imagen_ajust)
title('Ajuste Intensidad')

%% -- Eliminar Ruido -- %%
sigma = 3; %Desviación estándar para filtro gaussiano
blur_img = imgaussfilt(imagen_ajust, sigma); % Blur imagen
subplot 333
imshow(blur_img)
title('Blur')

%% -- Promedio para resaltar zonas claras -- %%
filtro_med = medfilt2(blur_img, [10 10]);
subplot 334
imshow(filtro_med)
title('Filtro Promedio');

%% -- Binarizar Imagen -- %%
umbral = 0.7;
im_binarizada = imbinarize(filtro_med, umbral);
subplot 335
imshow(im_binarizada)
title('Binarizada')

%% -- Obtener Datos de la Binarización -- %%
label = bwlabel(im_binarizada); %Identifica las regiones conectadas
datos_regiones = regionprops(label,'Solidity','Area'); %Obtener Propiedades
densidad  = [datos_regiones.Solidity];
area = [datos_regiones.Area];
mayor_densidad = densidad > 0.5; %Máscara, ayuda a filtrar áreas con poca densidad
max_area = max(area(mayor_densidad)); %Region con mayor área
tumor_label = find(area == max_area); %Busca exclusivamente las regiones con mayor area
tumor = ismember(label,tumor_label); %Binarización región del tumor

se = strel('square', 5); %Máscara 5px
tumor = imdilate(tumor, se);
subplot 336
imshow(tumor)
title('Tumor')

%% -- Contar tumores -- %%
tumores = bwlabel(tumor);
cantidad_tumores = max(tumores(:));
if cantidad_tumores == 0
    subplot 338
    imshow(entrada)
    title('No se encontró tumor.')
else
    %% -- Resalta tumor en imagen original -- %%
    resaltar_img = imoverlay(entrada, tumor, [1, 0, 0]); % Color amarillo
    subplot 338
    imshow(resaltar_img);
    title('Tumor Detectado.');
end