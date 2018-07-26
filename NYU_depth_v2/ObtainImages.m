    load('./NYUdepth/Code/nyu_depth_v2_labeled.mat');

    %%RGB images
    for i=1:size(rawRgbFilenames,1)
        folder = fullfile('NYUdepth/Images2', strtok(rawRgbFilenames{i,1},'/'))
        if ~exist(folder, 'dir')
            mkdir(folder)
        end
        imwrite(uint8(images(:,:,:,i)), sprintf('NYUdepth/Images2/%s.png', rawRgbFilenames{i,1}(1:end-4)));
    end
    
    %%Annotations for 40 classes 
    addpath(genpath('NYUdepth/Code/indoor_scene_seg_sup'))
    for i=1:size(rawRgbFilenames,1)
        folder = fullfile('NYUdepth/Annotations402', strtok(rawRgbFilenames{i,1},'/'))
        if ~exist(folder, 'dir')
            mkdir(folder)
        end
        str_labels = object2structure_labels_40(labels(:,:,i), names);
        str_labels = str_labels-1;
        str_labels(str_labels == -1) = 255;
        
        imwrite(uint8(str_labels), sprintf('NYUdepth/Annotations402/%s.png', rawRgbFilenames{i,1}(1:end-4)));
   end

