% if you use another test/train set change number of classes and the
% unlabeled index as well as number of iterations (needs to be equal to the test set size)

gtPath = '/home/carolina/projects/MESMERISE/EMdataset/valannot'; % path to your ground truth images
predPath = '/home/carolina/projects/MESMERISE/DeepLab/deeplab-caffe/EM/res/features/vgg128_noup/val/fc8/post_none/results/VOC2012/Segmentation/comp6_val_cls'; %path to your predictions (you get them after you implement saving images in the test_segmentation_camvid.py script - or you write your own)
groundTruths = dir(gtPath);
skip = 2; % first two are '.' and '..' so skip them
predictions = dir(predPath);

iter = 10;

numClasses = 2;
%unknown_class = 12;

totalpoints = 0;
cf = zeros(iter,numClasses,numClasses);
globalacc = 0;
idn = 1;
retrievalRes = 0;
falseAlarm = 0;
noDetect = 0;
posImg = 0;
count = 0;
DiceCoef = [];
WarpingError = [];
for i = 1:iter

    display(num2str(i));
    globalperimage = 0;
    pred_aux = imread(strcat(predPath, '/', predictions(i + skip).name)); % set this to iterate through your segnet prediction images
    pred = zeros(size(pred_aux,1), size(pred_aux,1));
    pred(pred_aux == 255) = 1;
    %load(strcat(predPath, '/', predictions(i + skip).name)); % set this to iterate through your segnet prediction images
    %pred = rgb_aux;
    %pred = round(imresize(pred, [512 512], 'bilinear'));
    pred = pred + 1; % i added this cause i labeled my classes from 0 to 11
    annot_aux = imread(strcat(gtPath, '/', groundTruths(i + skip).name)); % set this to iterate through your ground truth annotations
    %load(strcat(gtPath, '/', groundTruths(i + skip).name)); % set this to iterate through your ground truth annotations
    %annot = rgb_gt_aux;
    %annot = round(imresize(annot, [512 512], 'bilinear'));
    annot = zeros(size(annot_aux,1), size(annot_aux,1));
    annot(annot_aux == 255) = 1;
    annot = annot + 1; % i added this cause i labeled my classes from 0 to 11 -> so in that case the next line will find every pixel labeled with unknown_class=12

    %pixels_ignore = annot == unknown_class;
    %pred(pixels_ignore) = 0;
    %annot(pixels_ignore) = 0;
   
    totalpoints = totalpoints + sum(annot(:)>0);
    points_perimage = sum(annot(:)>0);
%     [DiceCoef(idn)]= DiceSimilarity2DImage(pred,annot, min(min(annot)));
%     idn = idn + 1;
%     count = count + 1;
    if sum(sum(annot-1))>0 || sum(sum(pred-1))>0
        [DiceCoef(idn)]= DiceSimilarity2DImage(pred,annot, min(min(annot)));
        idn = idn + 1;
        count = count + 1;
        
    end
    D  = sqrt(sum(sum((annot - pred) .^ 2)));
    WarpingError(i) = D/(size(pred,2)*size(pred,1));
    if sum(sum(annot-1))>0 && DiceCoef(idn - 1) > 0
         retrievalRes = retrievalRes + 1;
    end
    if sum(sum(annot-1))>0
        posImg = posImg + 1;
    end
    if (sum(sum(annot-1))>0 && DiceCoef(idn - 1) == 0)
        noDetect = noDetect + 1;
    end
    if (sum(sum(annot-1))==0 && sum(sum(pred-1))> 0) %...
            %|| (sum(sum(annot-1))>0 && DiceCoef(idn - 1) == 0)
        falseAlarm = falseAlarm + 1;
    end
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
    %if i ~= unknown_class && sum(cf(i,:)) > 0
        conf(i,:) = cf(i,:)/sum(cf(i,:));
    %end
end
globalacc = sum(globalacc)/sum(totalpoints);

% Compute intersection over union for each class and its mean
intoverunion = zeros(numClasses,1);
for i = 1:numClasses
    if sum(conf(i,:)) > 0
        intoverunion(i) = (cf(i,i))/(sum(cf(i,:))+sum(cf(:,i))-cf(i,i));
    end
end

display([' Global acc = ' num2str(globalacc) ' Class average acc = ' num2str(sum(diag(conf))/(numClasses)) ' Mean Int over Union = ' num2str(sum(intoverunion)/(numClasses))...
    ' DICE coeff = ' num2str(mean(DiceCoef))]);
display([' Warping Error = ' num2str(mean(WarpingError))]);
display([' Positive Images = ' num2str((posImg/(iter))*100)]);
display([' Retrieval results = ' num2str((retrievalRes/(iter))*100)]);
display([' No Detection results = ' num2str((noDetect/(iter))*100)]);
display([' False Alarm results = ' num2str((falseAlarm/(idn-1))*100)]);