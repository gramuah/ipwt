
%%Crop images
% dataset_folder = '/home/carlosh/workspace/DL-CARLOS/cityscapes_orig/leftImg8bit/all_train';
% destination_folder = '/home/carlosh/workspace/DL-CARLOS/cityscapes_orig/leftImg8bit/crop_train2';
% dataset_directory = dir(fullfile(dataset_folder, '*.png'));
% for i = 1 : numel(dataset_directory)
%     image = imread(fullfile(dataset_folder, dataset_directory(i).name));
%     for j=0:1
%         for k=0:0
%             crop = imcrop(image,[1024*j 1024*k 1024 1024]);
%             image_name = strrep(dataset_directory(i).name, '.png', ['_' num2str(j) num2str(k) '.png']);
%             imwrite(crop, fullfile(destination_folder, image_name));
%         end
%     end
% end
% for i = 1 : numel(dataset_directory)
%     image = imread(fullfile(dataset_folder, dataset_directory(i).name));
%     
%     crop = imcrop(image,[1 1 1119 1119]);
%     image_name = strrep(dataset_directory(i).name, '.png', ['_0.png']);
%     imwrite(crop, fullfile(destination_folder, image_name));
%     
%     crop = imcrop(image,[929 1 1119 1119]);
%     image_name = strrep(dataset_directory(i).name, '.png', ['_1.png']);
%     imwrite(crop, fullfile(destination_folder, image_name));     
% end
% for i = 1 : numel(dataset_directory)
%     image = imread(fullfile(dataset_folder, dataset_directory(i).name));
%     
%     crop = imcrop(image,[1 1 1023+512 1023]);
%     image_name = strrep(dataset_directory(i).name, '.png', ['_0.png']);
%     imwrite(crop, fullfile(destination_folder, image_name));
%     
%     crop = imcrop(image,[1024-512 1 1023+512 1023]);
%     image_name = strrep(dataset_directory(i).name, '.png', ['_1.png']);
%     imwrite(crop, fullfile(destination_folder, image_name));     
% end


%%Crop ground truth
% dataset_folder = '/home/carlosh/workspace/DL-CARLOS/cityscapes_orig/gtFine/all_train';
% destination_folder = '/home/carlosh/workspace/DL-CARLOS/cityscapes_orig/gtFine/crop_train2';
% dataset_directory = dir(fullfile(dataset_folder, '*labelTrainIds.png'));
% for i = 1 : numel(dataset_directory)
%     image = imread(fullfile(dataset_folder, dataset_directory(i).name));
%     for j=0:1
%         for k=0:0
%             crop = imcrop(image,[1024*j 1024*k 1024 1024]);
%             image_name = strrep(dataset_directory(i).name, '.png', ['_' num2str(j) num2str(k) '.png']);
%             imwrite(crop, fullfile(destination_folder, image_name));
%         end
%     end
% end
% for i = 1 : numel(dataset_directory)
%     image = imread(fullfile(dataset_folder, dataset_directory(i).name));
%     
%     crop = imcrop(image,[1 1 1023+512 1023]);
%     image_name = strrep(dataset_directory(i).name, '.png', ['_0.png']);
%     imwrite(crop, fullfile(destination_folder, image_name));
%     
%     crop = imcrop(image,[1024-512 1 1023+512 1023]);
%     image_name = strrep(dataset_directory(i).name, '.png', ['_1.png']);
%     imwrite(crop, fullfile(destination_folder, image_name));    
% end

%Get val.txt y val_id.txt


% sprintf(dir, '/home/carlosh/Desktop/cityscapes/leftImg8bit_trainvaltest/leftImg8bit/val/');
system('find /home/carlosh/workspace/DL-CARLOS/cityscapes_orig/leftImg8bit/crop_train2 -type f \( -iname \*.png \) > example.txt')

fid=fopen('example.txt');


tline = fgetl(fid);
tlines = cell(0,1);
while ischar(tline)
    tlines{end+1,1} = tline;
    tline = fgetl(fid);
end
fclose(fid);
val = 3; %% 1 val_id   2 val   3 train

if val==1
    tlines_sort = sort(tlines);
    tlines_sort = strrep(tlines_sort, '/home/carlosh/workspace/DL-CARLOS/cityscapes_orig/leftImg8bit/val_orig/crop2', '');
    tlines_sort = strrep(tlines_sort, '.png', '');
    imp = [tlines_sort];


    filePh = fopen('val_id.txt','w');
    [rows,cols]=size(imp);
     for r=1:rows
        fprintf(filePh,'%s\n',imp{r,1});
     end
     
elseif val == 2
    tlines_sort = sort(tlines);

   
    tlines_sort = strrep(tlines_sort, '/home/carlosh/workspace/DL-CARLOS/cityscapes_orig/leftImg8bit/val_orig/crop2', '/leftImg8bit/val_orig/crop2');
    seg_str = strrep(tlines_sort, '/leftImg8bit', '/gtFine');
    seg_str = strrep(seg_str, 'leftImg8bit', 'gtFine_labelTrainIds');
    seg_str = strrep(seg_str, '/home/carlosh/workspace/DL-CARLOS/cityscapes_orig/leftImg8bit/val_orig/crop2', '/gtFine/val_orig/crop2');
    imp = [tlines_sort seg_str];  

    filePh = fopen('val.txt','w');
    [rows,cols]=size(imp);
     for r=1:rows
        fprintf(filePh,'%s %s\n',imp{r,1}, imp{r,2});
     end
     
elseif val == 3
    tlines_sort = sort(tlines);
    tlines_sort = strrep(tlines_sort, '/home/carlosh/workspace/DL-CARLOS/cityscapes_orig/leftImg8bit/crop_train2', '/leftImg8bit/crop_train2');
    seg_str = strrep(tlines_sort, '/leftImg8bit', '/gtFine');
    seg_str = strrep(seg_str, 'leftImg8bit', 'gtFine_labelTrainIds');
    seg_str = strrep(seg_str, '/home/carlosh/workspace/DL-CARLOS/cityscapes_orig/gtFine/crop_train2', '/gtFine/crop_train2');
    imp = [tlines_sort seg_str];      

    filePh = fopen('train.txt','w');
    [rows,cols]=size(imp);
     for r=1:rows
        fprintf(filePh,'%s %s\n',imp{r,1}, imp{r,2});
     end
end



