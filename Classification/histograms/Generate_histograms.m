% This script generate the features (histograms) needed to perform scene
% classification from the semantic segmentation of an image as stated in 
% the IROS2018 paper "In pixels we trust: From Pixel Labeling to Object 
% Localization and Scene Categorization" IROS2018

load('../../NYU_depth_v2/NYUdepth/Code/nyu_depth_v2_labeled.mat');
load('../../NYU_depth_v2/NYUdepth/Code/splits.mat');

num_divisions = 2; % Choose the size of the Spatial Pyramid
conf.numClasses = 10 ;

%Labels
%classes = unique(sceneTypes);
classes = {'bedroom'; 'kitchen'; 'living_room'; 'bathroom'; 'dining_room'; 'office'; 'home_office'; 'classroom'; 'bookstore'...
    ;'basement'; 'cafe'; 'computer_lab'; 'conference_room'; 'dinette'; 'excercise_room'; 'foyer'; 'furniture_store';...
    'home_storage'; 'indoor_balcony'; 'laundry_room'; 'office_kitchen'; 'playroom' ; 'printer_room' ; 'reception_room';...
    'student_lounge'; 'study'; 'study_room'};

for i=1:size(scenes)
    ClassNumber(i,1) = find(strcmp(classes', sceneTypes(i)));
end

ClassTrain = ClassNumber(trainNdxs);
ClassTest = ClassNumber(testNdxs);
ClassTrain(ClassTrain>9)=10;
ClassTest(ClassTest>9)=10;

classes = {'bedroom'; 'kitchen'; 'living_room'; 'bathroom'; 'dining_room';...
    'office'; 'home_office'; 'classroom'; 'bookstore'; 'rest'};
imageClass = cat(1, ClassTrain, ClassTest) ;

%Images
ScenesTrain = rawRgbFilenames(trainNdxs);
ScenesTest = rawRgbFilenames(testNdxs);
clear images
for i=1:size(ScenesTrain)
    images{i,1} = ['../../NYU_depth_v2/NYUdepth/Images/', ScenesTrain{i,1}(1:end-4), '.png'];
end
for i=1:size(ScenesTest)
    images{i+size(ScenesTrain,1),1} = ['../../NYU_depth_v2/NYUdepth/Images/', ScenesTest{i,1}(1:end-4), '.png'];
end
for i=1:size(ScenesTrain)
    imagesSS{i,1} = ['../../NYU_depth_v2/NYUdepth/Annotations40/', ScenesTrain{i,1}(1:end-4), '.png'];
end
for i=1:size(ScenesTest)
    imagesSS{i+size(ScenesTrain,1),1} = ['../../deeplab_NYU/NYUdepth/res/features/resnet/val/crf/', ScenesTest{i,1}(1:end-4), '.png'];
end
        
selTrain = 1:size(ScenesTrain,1);
selTest = size(ScenesTrain,1):length(images);


 % Compute and save spatial histograms
  hists = {} ;
     parfor ii = 1:length(images)
        fprintf('Processing %s (%.2f %%)\n', images{ii}, 100 * ii / length(images)) ;
        im = imread(fullfile(images{ii})) ;
        im_seg = imread(fullfile(imagesSS{ii}));
        if ii>795
            im_seg = im_seg-1;
        end
        hists{ii} = ObtainHistograms(im_seg, num_divisions);
     end

  hists = cat(1, hists{:}) ;
  save(['features_' num2str(num_divisions) '_divisions.mat'],'hists') ;
