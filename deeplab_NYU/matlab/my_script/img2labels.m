function img2labels()

sourceDir = '/home/carolina/projects/MESMERISE/DeepLab/benchmark_RELEASE/dataset';
maskDir = [sourceDir, '/SegmentationClassAug'];
imgNames = textread([sourceDir, '/train_id.txt'], '%s');
outDir = [sourceDir, '/classlabels_ContextVOC12'];
for i =1:length(imgNames)
    label_clc = zeros(1, 20);
    fprintf('%s %d/%d\n', imgNames{i}, i, length(imgNames));
    img = imread([maskDir, '/', imgNames{i}, '.png']);
    if (find(img == 1))
        label_clc(1) = 1;
    end
    if (find(img == 2))
        label_clc(2) = 1;
    end
    if (find(img == 3))
        label_clc(3) = 1;
    end
    if (find(img == 4))
        label_clc(4) = 1;
    end
    if (find(img == 5))
        label_clc(5) = 1;
    end
    if (find(img == 6))
        label_clc(6) = 1;
    end
    if (find(img == 7))
        label_clc(7) = 1;
    end
    if (find(img == 8))
        label_clc(8) = 1;
    end
    if (find(img == 9))
        label_clc(9) = 1;
    end
    if (find(img == 10))
        label_clc(10) = 1;
    end
    if (find(img == 11))
        label_clc(11) = 1;
    end
    if (find(img == 12))
        label_clc(12) = 1;
    end
    if (find(img == 13))
        label_clc(13) = 1;
    end
    if (find(img == 14))
        label_clc(14) = 1;
    end
    if (find(img == 15))
        label_clc(15) = 1;
    end
    if (find(img == 16))
        label_clc(16) = 1;
    end
    if (find(img == 17))
        label_clc(17) = 1;
    end
    if (find(img == 18))
        label_clc(18) = 1;
    end
    if (find(img == 19))
        label_clc(19) = 1;
    end
    if (find(img == 20))
        label_clc(20) = 1;
    end
    save([outDir, '/', imgNames{i}, '.mat'], 'label_clc')
end
