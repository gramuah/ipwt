# In pixels we trust: From Pixel Labeling to Object Localization and Scene Categorization

This is a repository with the original implementation of the described solutions in our [IROS 2018 paper](https://arxiv.org/abs/1807.07284). 


### License

This repository is released under the GNU General Public License (refer to the LICENSE file for details).

### Citing

If you make use of this data and software, please cite the following reference in any publications:

	@Inproceedings{herranz2018,
	Author = {Herranz-Perdiguero, C. and Redondo-Cabrera, C. and L\'opez-Sastre, R.~J.},
	Title = {In pixels we trust: From Pixel Labeling to Object Localization and Scene Categorization},
	Booktitle = {IROS},
	Year = {2018}
	}

## Datasets and initial setup

1. In order to use this software, clone this repository. We will call that directory `PROJECT_ROOT`. There, we will have three folders:
- `PROJECT_ROOT/deeplab_NYU` contains the code needed to perform semantic segmentation.
- `PROJECT_ROOT/NYU_depth_v2` contains the NYU Depth v2 dataset.
- `PROJECT_ROOT/Classification` contains the code needed to perform scene classification.

2. Download the NYU Depth v2 dataset. To do so, go to `PROJECT_ROOT/NYU_depth_v2` and run the following script:
  ```
  cd $PROJECT_ROOT/NYU_depth_v2
  ./Download_NYU_depth.sh
  ```
 The dataset is saved in a .mat file which is located in `$PROJECT_ROOT/NYU_depth_v2/NYUdepth`
 
3. Now, to download a pretrained model to initialize the network and the best of our models, run: 
   ```
   cd $PROJECT_ROOT/NYU_depth_v2
  ./Download_Models.sh
  ``` 
You can find the file `init.caffemodel` in `$PROJECT_ROOT/deeplab_NYU/NYUdepth/model/resnet`. We will use that model to initialize the weights of the segmentation network. In `$PROJECT_ROOT/deeplab_NYU/NYUdepth/model/resnet/trained_model` you can find the final model used in our IROS 2018 paper.

4. Finally we need to extract the images from the .mat file we have downloaded. Under `PROJECT_ROOT/NYU_depth_v2` just run the Matlab script `ObtainImages.m`. Also, to overcome memory limitations, we will split the images in two halves with overlap. We can do that by running `SplitWholeDataset.m`.


## Image Segmentation

1. We need first to compile the DeepLab based model. Run:
  ```
  cd $PROJECT_ROOT/deeplab_NYU
  make
  make pycaffe
  make matcaffe
  ```
  
2. Once the compilation has been successfully completed, run:
  ```
  cd $PROJECT_ROOT/deeplab_NYU
  python run_NYUdepth.py
  ```
  to train or test a model. Please, note that in the script there is a flag to choose between train or test. By default, we search in `$PROJECT_ROOT/deeplab_NYU/NYUdepth/model/resnet` for a .caffemodel to initialize the weights of the network in the training step, or to find the model to use during testing.
  
3. To visualize the results after the test has been completed, run the Matlab script `GetSegResults_Split.m` with do_save_results to '1' in `$PROJECT_ROOT/deeplab_NYU/matlab/my_script_NYUdepth`. We will need these results to perform the scene classification task.
  
4. To evaluate the results using the different metrics reported in our paper run: `Get_mIOU.m` in `$PROJECT_ROOT/deeplab_NYU/matlab/my_script_NYUdepth`


## Scene classification
Once we have the results from our segmentation model, we can use them to categorize different scenes following the approach described in our paper. Simply:

1. In `PROJECT_ROOT/Classification/histograms`, run `Generate_histograms.m` to generate the histogram-like features from the segmented images. The code allows to choose the number of spatial pyramid levels you want to play with.
  
2. Under `PROJECT_ROOT/Classification/SVM`, you can find the models used to perform scene classification with both a Linear SVM and an Additive Kernel SVM. You just need to run `run_SVM.m` or `run_addtive_SVM.m`
