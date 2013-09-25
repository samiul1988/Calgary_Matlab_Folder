%%% This function computes the power sets without the null set of a given set (vector)
%%% example: if a = [1 2 3]; then p(a) = {[1], [2], [3], [1,2], [1,3],[2,3], [1,2,3]}

function [pSet, nCom] = powerSet(inputVector)

k = 1;

for i=1:length(inputVector)
    temp = combntns(inputVector,i);
    for j = 1:size(temp,1)
        pSet{k} = temp(j,:);
        k = k+1;
    end
end

nCom = length(pSet);