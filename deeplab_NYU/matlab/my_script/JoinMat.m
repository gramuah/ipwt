clear
close all;
SetupEnvCS;
%%Crop images
mat_folder = '/home/carlosh/workspace/DL-CARLOS/deeplab-Carlos/cityscapes/features/vgg128_noup/val/crf';
save_folder = '/home/carlosh/workspace/DL-CARLOS/deeplab-Carlos/cityscapes/features/vgg128_noup/val/crf/png';
mat_directory = dir(fullfile(mat_folder, '*.mat'));
for i = 1: 2: numel(mat_directory)
    data1 = load(fullfile(mat_folder, mat_directory(i).name));
    raw_result1 = data1.data;
    raw_result1 = permute(raw_result1, [2 1 3]);
    result1 = raw_result1(1:1024, 1:1120, :);
    
    img_fn = mat_directory(i).name(1:end-4);
    img_fn = strrep(img_fn, '_0_blob_0', '');

    
    data2 = load(fullfile(mat_folder, mat_directory(i+1).name));
    raw_result2 = data2.data;
    raw_result2 = permute(raw_result2, [2 1 3]);
    result2 = raw_result2(1:1024, 1:1120, :);
    
    
% 
%     
%     data3 = load(fullfile(mat_folder, mat_directory(i+2).name));
%     raw_result3 = data3.data;
%     raw_result3 = permute(raw_result3, [2 1 3]);
%     result3 = raw_result3(1:512, 1:512, :);
% 
%     
%     data4 = load(fullfile(mat_folder, mat_directory(i+3).name));
%     raw_result4 = data4.data;
%     raw_result4 = permute(raw_result4, [2 1 3]);
%     result4 = raw_result4(1:512, 1:512, :);
% 
%     
%  
%     data5 = load(fullfile(mat_folder, mat_directory(i+4).name));
%     raw_result5 = data5.data;
%     raw_result5 = permute(raw_result5, [2 1 3]);
%     result5 = raw_result5(1:512, 1:512, :);
% 
%     
%     data6 = load(fullfile(mat_folder, mat_directory(i+5).name));
%     raw_result6 = data6.data;
%     raw_result6 = permute(raw_result6, [2 1 3]);
%     result6 = raw_result6(1:512, 1:512, :);
% 
%     
%     data7 = load(fullfile(mat_folder, mat_directory(i+6).name));
%     raw_result7 = data7.data;
%     raw_result7 = permute(raw_result7, [2 1 3]);
%     result7 = raw_result7(1:512, 1:512, :);
% 
%     
%     data8 = load(fullfile(mat_folder, mat_directory(i+7).name));
%     raw_result8 = data8.data;
%     raw_result8 = permute(raw_result8, [2 1 3]);
%     result8 = raw_result8(1:512, 1:512, :);

    
%    result = [result1 result3 result5 result7; result2 result4 result6 result8];
%    result = [result1 result2];
    
    result =  zeros(1024, 2048, 19, 'single');
    result(1:1024, 1:1120,:) = result1;
    result(1:1024, 929:2048, :) = result(1:1024, 929:2048, :) + result2;
    
    
    all_raw_result = zeros(1024, 2048, 19, 'single');
    if ~is_argmax
      [~, result] = max(result, [], 3);
      result = uint8(result) - 1;
    else
      result = uint8(result);
    end
    
    result_copia = result;
    
    result_copia(result == 0) = 7;
    result_copia(result == 1) = 8;
    result_copia(result == 2) = 11;
    result_copia(result == 3) = 12;
    result_copia(result == 4) = 13;
    result_copia(result == 5) = 17;
    result_copia(result == 6) = 19;
    result_copia(result == 7) = 20;
    result_copia(result == 8) = 21;
    result_copia(result == 9) = 22;
    result_copia(result == 10) = 23;
    result_copia(result == 11) = 24;
    result_copia(result == 12) = 25;
    result_copia(result == 13) = 26;
    result_copia(result == 14) = 27;
    result_copia(result == 15) = 28;
    result_copia(result == 16) = 31;
    result_copia(result == 17) = 32;
    result_copia(result == 18) = 33;
    result_copia(result == 255) = 1;
    
    load('colormapcs.mat');
    %%imshow(result, colormapcs);
    %%imshow(result, colormapcs);
    %%waitforbuttonpress;
    
    imwrite(result_copia, colormapcs, fullfile(save_folder, [img_fn, '.png']));
    
    
    
end

