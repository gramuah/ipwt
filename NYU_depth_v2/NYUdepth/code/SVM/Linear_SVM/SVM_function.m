function [Accuracy] = SVM_1_vs_all(Design, Test)

for i=1:size(Design.T,1)
    S=fitcsvm(Design.P', Design.T(i,:)', 'Standardize', true,  'KernelScale', 'auto', 'KernelFunction', 'linear');
    [~, score]=predict(S, Test.P');
    Y(i,:) = score(:,2);
end

[~,predicted_class] = max(Y);
[~,real_class] = max(Test.T);
Accuracy = mean(predicted_class==real_class);
end