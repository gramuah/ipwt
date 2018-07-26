% if you use another test/train set change number of classes and the
% unlabeled index as well as number of iterations (needs to be equal to the test set size)

%Load Dataset
load('../../../NYU_depth_v2/NYUdepth/Code/nyu_depth_v2_labeled.mat');
load('../../../NYU_depth_v2/NYUdepth/Code/splits.mat');

%Set root path to the images
ROOT_PATH = ['../../NYUdepth/'];

%Parameters
dataset = 'NYUdepth';
load_folder = 'features';
net_id = 'resnet';
test_set = 'val';     % 'val_fine', 'test_fine'
feature_types = 'crf';       % 'crf', 'fc8'

ScenesTest = rawRgbFilenames(testNdxs);
gtPath = ['../../../NYU_depth_v2/' dataset '/Annotations40']; % path to your ground truth images
predPath = fullfile(ROOT_PATH, 'res', load_folder, net_id, test_set, feature_types); %path to your predictions (you get them after you implement saving images in the test_segmentation_camvid.py script - or you write your own)
groundTruths = dir(gtPath);
skip = 2; % first two are '.' and '..' so skip them
predictions = dir(predPath);

%Number of test images
iter = 654;

numClasses = 40;
unknown_class = 255;

totalpoints = 0;
cf = zeros(iter,numClasses,numClasses);
globalacc = 0;
pix_acc = 0;

for i = 1:iter
    display(num2str(i));

    pred = imread(strcat(predPath, '/', sprintf('%s.png', ScenesTest{i,1}(1:end-4)))); % set this to iterate through your segnet prediction images
    %pred = pred + 1; % i added this cause i labeled my classes from 0 to 11
    annot = imread(strcat(gtPath, '/', sprintf('%s.png', ScenesTest{i,1}(1:end-4)))); % set this to iterate through your ground truth annotations
    annot = annot + 1; % i added this cause i labeled my classes from 0 to 11 -> so in that case the next line will find every pixel labeled with unknown_class=12

    pixels_ignore = annot == unknown_class;
    pred(pixels_ignore) = 0;
    annot(pixels_ignore) = 0;
   
    totalpoints = totalpoints + sum(annot(:)>0);

    % global and class accuracy computation
    for j = 1:numClasses
        for k = 1:numClasses
                c1  = annot == j;
                c1p = pred == k;
                index = gather(c1 .* c1p);              
                cf(i,j,k) = cf(i,j,k) + sum(index(:));
        end
            c1  = annot == j;
            c1p = pred == j;
            index = gather(c1 .* c1p);
            globalacc = globalacc + sum(index(:));
            pix_acc = pix_acc + sum(index(:));
        
    end
        pixelwise_acc(i) = pix_acc/sum(annot(:)>0);
        pix_acc = 0;
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