% Split the images in two overlapping halves

%Where to save the new dataset
save_path = 'NYUdepth';

if ~exist(save_path, 'dir')
    mkdir(save_path);
end

%Path to the original dataset
dataset_path = 'NYUdepth';

dataset_dir = dir(dataset_path);

%
for ii = 1 : numel(dataset_dir)
    if strcmp(dataset_dir(ii).name, '.') || strcmp(dataset_dir(ii).name, '..')
        continue;
    end
    % only split the images
    if ~strcmp(dataset_dir(ii).name, 'Images')
        continue;
    end
    
    % Directory containing folders of images grouped by class
    one_path_down_dir = dir(fullfile(dataset_path, dataset_dir(ii).name));    
    
    %For each of those folders
    for jj = 1 : numel(one_path_down_dir)
        if strcmp(one_path_down_dir(jj).name, '.') || strcmp(one_path_down_dir(jj).name, '..')                 
            continue;
        end
        if ~isdir(fullfile(dataset_path, dataset_dir(ii).name, one_path_down_dir(jj).name))
            continue;
        end
            
            %Get the  images
            imgs = dir(fullfile(dataset_path, dataset_dir(ii).name, one_path_down_dir(jj).name, ...
                '*.png'));
            
            if numel(imgs) > 0
                save_dir = fullfile(save_path, [dataset_dir(ii).name, '_split2'], one_path_down_dir(jj).name);
            
                if ~exist(save_dir, 'dir')
                    mkdir(save_dir);
                end
            else
                continue;
            end
            %Split them in two parts with overlap
            for mm = 1 : numel(imgs)
                fprintf(1, 'processing %d (%d)\n', mm, numel(imgs));
                img = imread(fullfile(dataset_path, dataset_dir(ii).name, one_path_down_dir(jj).name, ...
                    imgs(mm).name));
            
                ims = cell(1, 2);
                
                img_row = size(img, 1);
                img_col = size(img, 2);
                
                for row = 1
                    for col = 1 : 2
                        pos = (row - 1) * 4 + col - 1;
                        
                        if col == 1
                            top_left = [1, 1];
                            bot_right = [480, 512];
                        elseif col == 2
                            top_left = [1, 129];
                            bot_right = [480, 640];
                        end
                        
                        ims{pos+1} = img(top_left(1):bot_right(1), top_left(2):bot_right(2), :);
                        
                        img_fn = [imgs(mm).name(1:end-4), sprintf('_pos%d', pos), '.png'];
                        
                        save_fn = fullfile(save_path, [dataset_dir(ii).name, '_split2'], one_path_down_dir(jj).name, ...
                             img_fn);
                        imwrite(ims{pos+1}, save_fn);                        
                    end
                end
    
            end
    end
end

    
    