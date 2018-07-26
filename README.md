# ipwt
This repository includes the code to reproduce the experiments of our IROS 2018 paper, titled: "In pixels we trust: From Pixel Labeling to Object Localization and Scene Categorization".

### DATASET AND INITIAL SETUP 

1. In order to use this software, clone this repository. We will call that directory `PROJECT_ROOT`.
There, we will have two folders:

- `PROJECT_ROOT/deeplab_NYU` contains the code needed to perform semantic segmentation. 
- `PROJECT_ROOT/NYU_depth_v2` contains the NYU Depth v2 dataset and the code needed to perform scene classification as stated in the paper.

2. First, lets download the NYU Depth v2 dataset. To do so, go to `PROJECT_ROOT/NYU_depth_v2` and run:
  ```
  $PROJECT_ROOT/NYU_depth_v2
  ./Download_NYU_depth.sh
  ```
 The dataset is stored in a .mat file which is stored in `$PROJECT_ROOT/NYU_depth_v2/NYUdepth/code`.
 
 3. Now, to download a pretrained model to initialize the network and the best of our models, run:
 
   ```
   $PROJECT_ROOT/NYU_depth_v2
  ./Download_Models.sh
  ```
  
You can find the file `init.caffemodel` in `$PROJECT_ROOT/deeplab_NYU/NYUdepth/model/resnet`, we will use that model to initialize the weights of the segmentation network. In `$PROJECT_ROOT/deeplab_NYU/NYUdepth/model/resnet/trained_model` you can find the final model used in our paper.

4. Finally we will extract the images from the .mat file we have downloaded. Under `PROJECT_ROOT/NYU_depth_v2` just run `ObtainImages.m`. Also, to overcome memory limitations, we will split the images in two halves with overlap. We can do that by running `SplitWholeDataset.m`


### DEEPLAB BASED MODEL FOR IMAGE SEGMENTATION

1. In order to use deeplab, let's compile the caffe framework. Run:
  ```
  $PROJECT_ROOT/deeplab_NYU
  make
  make pycaffe
  make matcaffe
  ```
  
2. Once the compilation has been successfully completed, just run
  ```
  $PROJECT_ROOT/deeplab_NYU
  python run_NYUdepth.py
  ```
  to train or test a model. PLease, note that in the script there is a flag to choose between train or test. By default, we search in `$PROJECT_ROOT/deeplab_NYU/NYUdepth/model/resnet` for a .caffemodel to initialize the weigths of the network.
  
3. To visualize the results after the test has been completed, run `$PROJECT_ROOT/deeplab_NYU/matlab/my_script_NYUdepth/GetSegResults_Split.m` with do_save_results to '1'. We will need then to perform scene classification
  
4. To evaluate the results in different metrics run `$PROJECT_ROOT/deeplab_NYU/matlab/my_script_NYUdepth/Get_mIOU.m`


### PERFORMING SCENE CLASSIFICATION
Once we have the results from our segmentation model:

1. In `PROJECT_ROOT/NYU_depth_v2/NYU_depth/histograms`, run `Generate_histograms.m` to generate the histogram-like features from the segmented images. The code allows to choose the number of spatial pyramid levels.
  
2. Under `PROJECT_ROOT/NYU_depth_v2/NYU_depth/code/SVM`, you can find the models used to perform scene classification with both a Linear SVM and an Additive Kernel SVM. You just need to run `run_SVM.m` or `run_addtive_SVM.m`.