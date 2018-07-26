% Additive kernel classification. Reproducing IROS2018 NYUdepth
% results.

% Based on the algorithm from : 
%
% Classification using Intersection Kernel SVMs is efficient, 
% Subhransu Maji, Alexander C. Berg, Jitendra Malik, CVPR 2008



% compile the mex files
if(exist('mex_linear_interpolate')~= 3 || ...
        exist('mex_sample_weighted_int_kernel')~= 3 || ...
            exist('mex_sample_weighted_kernel') ~= 3)
        make;
end
        

% path to the latest libsvm supported for additive kernels
libsvmpath = 'libsvm-mat-3.0-1';
addpath(libsvmpath);

% loop over kernel types and train models
KERNEL_TYPES = [5 6 7]; 
classes = 10;

%%Load labels
load('../../../histograms/class_labels.mat')

%Load features/histograms
load('../../../histograms/features_2_divisions.mat')


%Divide between train and test
x = hists(1:795,:);
x_test = hists(796:end, :);
x_test(x_test==0)=0.0001;

% Labels train and test
l= imageClass(1:795);
l_test= imageClass(796:end);

% Loop over kernel types
for i = 1:length(KERNEL_TYPES),
    fprintf('\n\n\nTesting for KERNEL type : %i \n',KERNEL_TYPES(i));
    for ci = 1:classes
        y = 2 * (l == ci) - 1 ;
        y_test = 2 * (l_test == ci) - 1 ;  
        svmmodel = svmtrain(y,x,sprintf('-t %i -b 1',KERNEL_TYPES(i)));
        
        % use this to predict the values
        [svml,svmap,svmd] = svmpredict(y_test,x_test,svmmodel,'-b 1');
        prob_class(:,ci) = svmd(:,svmmodel.Label==1);    %# probability of class==k
    end
    
    [~, pred_class] = max(prob_class,[],2);
    accuracy = sum(pred_class == l_test)/654
end
