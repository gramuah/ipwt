function [eval_results] = TransformTrainidToId(result, trainID_to_id)
% transform the trainIds to Ids for evaluation
%

eval_results = result;

labels = unique(result(:));

for ii = 1 : length(labels)
    label = labels(ii);
    id = trainID_to_id(label+1);

    ind = result == label;
    eval_results(ind) = id;

end

