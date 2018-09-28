SetupEnvCS;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% You do not need to chage values below
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


  if strcmp(dataset, 'cityscapes')
    VOC_root_folder = '/home/carlosh/workspace/DL-CARLOS/cityscapes/';
  else
    error('Wrong dataset');
  end

  post_folder = 'post_none';


output_mat_folder = fullfile('/home/carlosh/workspace/DL-CARLOS/deeplab-Carlos/', dataset, feature_name, model_name, testset, feature_type);
save_root_folder = fullfile('/home/carlosh/workspace/DL-CARLOS/deeplab-Carlos/', dataset, 'res', feature_name, model_name, testset, feature_type, post_folder);

fprintf(1, 'Saving to %s\n', save_root_folder);

if strcmp(dataset, 'cityscapes')
  seg_res_dir = [save_root_folder '/results/cityscapes/'];
  seg_root = fullfile(VOC_root_folder, '');
  gt_dir   = fullfile(VOC_root_folder, '', 'gtFine/val_orig/crop1'); %%all_val
  
elseif strcmp(dataset, 'coco')
  seg_res_dir = [save_root_folder '/results/COCO2014/'];
  seg_root = fullfile(VOC_root_folder, '');
  gt_dir   = fullfile(VOC_root_folder, '', 'SegmentationClass');
end

save_result_folder = fullfile(seg_res_dir, 'Segmentation', [id '_' testset '_cls']);

if ~exist(save_result_folder, 'dir')
    mkdir(save_result_folder);
end

if is_mat
  % crop the results
  load('colormapcs.mat');

  output_dir = dir(fullfile(output_mat_folder, '*.mat'));

  for i = 1 : numel(output_dir)
    if mod(i, 100) == 0
        fprintf(1, 'processing %d (%d)...\n', i, numel(output_dir));
    end

    data = load(fullfile(output_mat_folder, output_dir(i).name));
    raw_result = data.data;
    raw_result = permute(raw_result, [2 1 3]);
    img_fn = output_dir(i).name(1:end-4);
    img_fn = strrep(img_fn, '_blob_0', '');
    
    img_fn_2 = strrep(img_fn, '_leftImg8bit', '_gtFine_labelTrainIds');
    
    if strcmp(dataset, 'cityscapes')
       img = imread(fullfile(VOC_root_folder, 'leftImg8bit/val_orig/crop1/', [img_fn, '.png'])); %%val/all_val
    end
    
    img_row = size(img, 1);
    img_col = size(img, 2);
    
    result = raw_result(1:img_row, 1:img_col, :);

    if ~is_argmax
      [~, result] = max(result, [], 3);
      result = uint8(result) - 1;
    else
      result = uint8(result);
    end

    if debug
        gt = imread(fullfile(gt_dir, [img_fn_2, '.png']));
        figure(1), 
        subplot(221),imshow(img), title('img');
        subplot(222),imshow(gt, colormapcs), title('gt');
        subplot(224), imshow(result,colormapcs), title('predict');
        %waitforbuttonpress;
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
    imwrite(result_copia, colormapcs, fullfile(save_result_folder, [img_fn, '.png']));
  end
end


fprintf(1, 'Done\n');

    
    

