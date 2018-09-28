[ids, dummy] = textread('/home/carolina/projects/MESMERISE/DeepLab/benchmark_RELEASE/dataset/train_aug.txt', '%s %s');
fid = fopen('/home/carolina/projects/MESMERISE/DeepLab/benchmark_RELEASE/dataset/train_id.txt','w');

for i=1:length(ids)
    fprintf(fid, '%s\n', ids{i});
end