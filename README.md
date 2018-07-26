# ipwt
This repository includes the code to reproduce the experiments of our IROS 2018 paper, titled: "In pixels we trust: From Pixel Labeling to Object Localization and Scene Categorization".


# USAGE

In order to use this software, clone this repository. We will call that directory `PROJECT_ROOT`.
We have two folders:

1. `PROJECT_ROOT/deeplab_NYU` contains the code needed to perform semantic segmentation. 
  - First, compile caffe:
  `$PROJECT_ROOT/deeplab_NYU,
  make
  make pycaffe
  make matcaffe
  `
  - Once the compilation has been successfully completed, just run
  `python run_NYUdepth.py`
  to train or test the a model. PLease, note that inside the script there is a flag to choose between train or test.
  
  - To visualize the results after the test has been completed, run `$PROJECT_ROOT/deeplab_NYU/matlab/my_script_NYUdepth/GetSegResults_Split.m` with do_save_results to '1'.
  
  - To evaluate the results in different metrics run `$PROJECT_ROOT/deeplab_NYU/matlab/my_script_NYUdepth/Get_mIOU.m`


2. `PROJECT_ROOT/NYU_depth_v2/NYU_depth` contains the NYU Depth v2 dataset and the code needed to perform scene classification as stated in the paper.

  - In `PROJECT_ROOT/NYU_depth_v2/NYU_depth/histograms`, run `Generate_histograms.m` to generate the histogram-like features from the segmented images. The code allows to choose the number of spatial pyramid levels.
  
  - Under `PROJECT_ROOT/NYU_depth_v2/NYU_depth/code/SVM`, you can find the models used to perform scene classification with both a Linear SVM and an Additive Kernel SVM. You just need to run `run_SVM.m` or `run_addtive_SVM.m`.



Under construction. Models and data coming soon.
