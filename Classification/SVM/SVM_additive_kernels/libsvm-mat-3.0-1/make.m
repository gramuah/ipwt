% This make.m is used under Windows

%add -largeArrayDims on 64-bit machines

mex -O -c svm.cpp -largeArrayDims
mex -O -c svm_model_matlab.c -largeArrayDims
mex -O svmtrain.c svm.o svm_model_matlab.o -largeArrayDims
mex -O svmpredict.c svm.o svm_model_matlab.o -largeArrayDims
mex -O libsvmread.c -largeArrayDims
mex -O libsvmwrite.c -largeArrayDims
