% Transform the features computed by deeplab (saved as .mat) to the format
% suitable for evaluation
% The results are split into two mat files; We will merge them for evaluation

% clear all; close all;

NYUdepth_cmap;

dataset = 'NYUdepth';

num_classes = '40';

%In order to test the model and to overcome memory limitations we divide
%the image in two overlapping halves
num_split = 2;

% Compare the results with the ground-truth
debug = 0;

% Set to '1' to save qualitative results
do_save_results = 0;

% Set to '1' to save a .mat with the combined result of both halves
do_save_mat_results = 0;

load_folder = 'features';
net_id = 'resnet';

test_set = 'val';  
feature_types = {'crf'};       % 'crf', 'fc8'


ROOT_PATH = ['../../' dataset];
IMG_ROOT =['../../../NYU_depth_v2/' dataset]; 



for kk = 1 : numel(feature_types)
    
    folder_names = dir(fullfile(ROOT_PATH, load_folder, net_id, test_set, feature_types{kk}));

    % load list
    list_fid = fopen(fullfile(ROOT_PATH, 'list', [test_set, '.txt']));
    list = textscan(list_fid, '%s\n');
    list = list{1};
    
    % visualization results, not used for evaluation, but for color visualization
    vis_save_folder = fullfile('vis_res', load_folder);

    % used for evaluation    
    save_folder = fullfile('res', load_folder);

    num_img=0;
    for ii = 1 : numel(folder_names)
        if strcmp(folder_names(ii).name, '.') || strcmp(folder_names(ii).name, '..')
            continue;
        end

        cur_path = fullfile(ROOT_PATH, load_folder, net_id, test_set, feature_types{kk}, folder_names(ii).name);
        results = dir(fullfile(cur_path, '*.mat'));

        save_mat_path = fullfile(ROOT_PATH,  load_folder, net_id, test_set, feature_types{kk}, folder_names(ii).name);
        save_path = fullfile(ROOT_PATH,  save_folder, net_id, test_set, feature_types{kk}, folder_names(ii).name);
        vis_save_path = fullfile(ROOT_PATH, vis_save_folder, net_id, test_set, feature_types{kk}, folder_names(ii).name);

        if ~exist(vis_save_path, 'dir')
            mkdir(vis_save_path)
        end

        if ~exist(save_path, 'dir')
            mkdir(save_path)
        end

        if ~exist(save_mat_path, 'dir')
            mkdir(save_mat_path)
        end
        
        filenames = {results.name};
        for mm = 1 : length(filenames)
            pos = strfind(filenames{mm}, '_pos');
            if isempty(pos)
                continue;
            end
            filenames{mm} = filenames{mm}(1:pos-1);
        end
        filenames = unique(filenames);
        
        for jj = 1 : numel(filenames) 
            num_img = num_img +1;
            fprintf(1, 'processing image %d of 654...\n', num_img);
            
            fn =filenames{jj};

            counts = zeros(480, 640, 'single');
            all_raw_result = zeros(480, 640, 40, 'single');
            for mm = 1 : num_split
                tmp = load(fullfile(cur_path, [filenames{jj}, sprintf('_pos%d_blob_0', mm-1), '.mat']));
                if mm == 1
                    top_left = [1, 1];
                    pad = [1, 1];    % amount of padding for mat files
                elseif mm == 2
                    %top_left = [1, 401];
                    top_left = [1, 129];
                    pad = [1, 1];    % amount of padding for mat files
                end
                
                raw_result = tmp.data;
                raw_result = permute(raw_result, [2 1 3]);
                raw_result = raw_result(1:end-pad(1), 1:end-pad(2), :);
                
                max_row = min(top_left(1)+size(raw_result,1)-1, 480);
                max_col   = min(top_left(2) + size(raw_result,2) - 1, 640);
                all_raw_result(top_left(1):max_row, top_left(2):max_col, :) = ...
                    all_raw_result(top_left(1):max_row, top_left(2):max_col, :) + raw_result;
                 counts(top_left(1):max_row, top_left(2):max_col) = ...
                     counts(top_left(1):max_row, top_left(2):max_col) + 1;
            end
            all_raw_result = bsxfun(@rdivide, all_raw_result, counts);
            
            [~, result] = max(all_raw_result, [], 3);
            
            result = uint8(result);
                       
            if debug              
                % RGB image
                figure(1)
                img_path = fullfile(IMG_ROOT, '/Images/', folder_names(ii).name);
                img = imread(fullfile(img_path, [fn '.png']));
                subplot(2, 2, 1), imshow(img)                
                %Segmentation result 
                subplot(2, 2, 2), imagesc(result-1, [0 str2double(num_classes)])
                %Segmentation Annotated
                img_path = fullfile(IMG_ROOT, 'Annotations40/', folder_names(ii).name);                
                img = imread(fullfile(img_path, [fn '.png']));
                subplot(2, 2, 4), imagesc(img, [0 str2double(num_classes)])
                pause
            end

            if do_save_mat_results
                data = all_raw_result;                
                save(fullfile(save_mat_path, [filenames{jj}, '_blob_0', '.mat']), 'data');
            end
                
            if do_save_results
                imwrite(result, fullfile(save_path, [fn '.png']));
                NYUdepth.cmap_id = zeros(256, 3);
                colours = parula(40);
                NYUdepth.cmap_id(1:40, :) = colours;
                results_modify = zeros(480,680,3);
                aux1 = zeros(480,640);
                aux2 = zeros(480,640);
                aux3 = zeros(480,640);
                for jjj=1:255
                    aux1(result==jjj) = NYUdepth.cmap_id(jjj,1);
                    aux2(result==jjj) = NYUdepth.cmap_id(jjj,2);
                    aux3(result==jjj) = NYUdepth.cmap_id(jjj,3);
                    results_modify = cat(3,aux1,aux2,aux3);
                end
                imwrite(results_modify, fullfile(vis_save_path, [fn '.png']))
            end          

        end
    end
end
