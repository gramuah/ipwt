%%colormap=load('pascal_seg_colormap.mat');
colormap=load('colormapcs.mat');

output_dir = dir(fullfile('/home/carlosh/workspace/DL-CARLOS/deeplab-Carlos/cityscapes/features/vgg128_noup/val/crf/', '*.mat'));
input_dir = dir(fullfile('/home/carlosh/workspace/DL-CARLOS/cityscapes/leftImg8bit/val/all_val/', '*.png'));

for i = 1 : numel(output_dir)
    
    data = load(fullfile('/home/carlosh/workspace/DL-CARLOS/deeplab-Carlos/cityscapes/features/vgg128_noup/val/crf/', output_dir(i).name)); 
    original_image = imread(fullfile('/home/carlosh/workspace/DL-CARLOS/cityscapes/leftImg8bit/val/all_val/', input_dir(i).name));

    raw_result = data.data;
    raw_result = permute(raw_result, [2 1 3]);
    [~, result] = max(raw_result, [], 3);
    result = uint8(result) - 1;
    result_copia = result;
    
    result_copia(result == 7) = 0;
    result_copia(result == 8) = 1;
    result_copia(result == 11) = 2;
    result_copia(result == 12) = 3;
    result_copia(result == 13) = 4;
    result_copia(result == 17) = 5;
    result_copia(result == 19) = 6;
    result_copia(result == 20) = 7;
    result_copia(result == 21) = 8;
    result_copia(result == 22) = 9;
    result_copia(result == 23) = 10;
    result_copia(result == 24) = 11;
    result_copia(result == 25) = 12;
    result_copia(result == 26) = 13;
    result_copia(result == 27) = 14;
    result_copia(result == 28) = 15;
    result_copia(result == 31) = 16;
    result_copia(result == 32) = 17;
    result_copia(result == 33) = 18;
    result_copia(result < 7) = 255;
    result_copia(result == 9) = 255;
    result_copia(result == 10) = 255;
    result_copia(result == 14) = 255;
    result_copia(result == 15) = 255;
    result_copia(result == 16) = 255;
    result_copia(result == 18) = 255;
    result_copia(result > 33) = 255;
    
    
    figure(1)
    imshow(result, colormap.colormapcs);
    hold on;
    figure(2)
    imshow(original_image);
    
    waitforbuttonpress;
end