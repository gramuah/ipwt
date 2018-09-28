% if you use another test/train set change number of classes and the
% unlabeled index as well as number of iterations (needs to be equal to the test set size)

gtPath = '/home/carolina/projects/MESMERISE/caffe-segnet-segnet-cleaned/examples/SegNet-Tutorial-master/CamVid/testannot'; % path to your ground truth images
predPath = '/home/carolina/projects/MESMERISE/DeepLab/deeplab-caffe/CamVid/res/features/vgg128_noup/val/fc8/post_none/results/VOC2012/Segmentation/comp6_val_cls'; %'/home/carolina/projects/MESMERISE/DeepLab/deeplab-caffe/CamVid/res_init_vgg16/features/vgg128_noup/val/fc8/post_none/results/VOC2012/Segmentation/comp6_val_cls'; %path to your predictions (you get them after you implement saving images in the test_segmentation_camvid.py script - or you write your own)
groundTruths = dir(gtPath);
skip = 2; % first two are '.' and '..' so skip them
predictions = dir(predPath);

iter = 233;

numClasses = 11;
unknown_class = 12;

totalpoints = 0;
cf = zeros(iter,numClasses,numClasses);
globalacc = 0;

for i = 1:iter
    display(num2str(i));
    globalperimage = 0;
    pred = imread(strcat(predPath, '/', predictions(i + skip).name)); % set this to iterate through your segnet prediction images
    %load(strcat(predPath, '/', predictions(i + skip).name)); % set this to iterate through your segnet prediction images
    %pred = rgb_aux;
    pred = pred + 1; % i added this cause i labeled my classes from 0 to 11
    annot = imread(strcat(gtPath, '/', groundTruths(i + skip).name)); % set this to iterate through your ground truth annotations
    %load(strcat(gtPath, '/', groundTruths(i + skip).name)); % set this to iterate through your ground truth annotations
    %annot = rgb_gt_aux;
    annot = annot + 1; % i added this cause i labeled my classes from 0 to 11 -> so in that case the next line will find every pixel labeled with unknown_class=12

    pixels_ignore = annot == unknown_class;
    pred(pixels_ignore) = 0;
    annot(pixels_ignore) = 0;
   
    totalpoints = totalpoints + sum(annot(:)>0);
    points_perimage = sum(annot(:)>0);

    % global and class accuracy computation
    for j = 1:numClasses
        c1  = annot == j;
        for k = 1:numClasses
                c1p = pred == k;
                index = gather(c1 .* c1p);              
                cf(i,j,k) = cf(i,j,k) + sum(index(:));
        end
        c1p = pred == j;
        index = gather(c1 .* c1p);
        globalacc = globalacc + sum(index(:));
        globalperimage = globalperimage + sum(index(:)); 
    end
    
    acc_perimage(i) = globalperimage/points_perimage;
end

cf = sum(cf,1);
cf = squeeze(cf);

% Compute confusion matrix
conf = zeros(numClasses);
for i = 1:numClasses
    if i ~= unknown_class && sum(cf(i,:)) > 0
        conf(i,:) = cf(i,:)/sum(cf(i,:));
    end
end
globalacc = sum(globalacc)/sum(totalpoints);

% Compute intersection over union for each class and its mean
intoverunion = zeros(numClasses,1);
for i = 1:numClasses
    if i ~= unknown_class   && sum(conf(i,:)) > 0
        intoverunion(i) = (cf(i,i))/(sum(cf(i,:))+sum(cf(:,i))-cf(i,i));
    end
end

display([' Global acc = ' num2str(globalacc) ' Class average acc = ' num2str(sum(diag(conf))/(numClasses)) ' Mean Int over Union = ' num2str(sum(intoverunion)/(numClasses))]);