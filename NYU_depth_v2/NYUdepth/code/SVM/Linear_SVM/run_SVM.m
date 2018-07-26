clear all

%%Load labels
load('../../../histograms/class_labels.mat')

%Load features/histograms
load('../../../histograms/features_3_divisions.mat')

%NYU depth training images
im_train = 795;
%Number of possible classes
num_classes = 10;

Design.P = hists(1:im_train,:)';
Test.P = hists(im_train+1:end,:)';

for i=1:num_classes
    Design.T(i,:) = imageClass(1:im_train)' == i;
    Test.T(i,:) = imageClass(im_train+1:end)' == i;
end

%%Use SVM to classify
Accuracy = SVM_function(Design, Test)


