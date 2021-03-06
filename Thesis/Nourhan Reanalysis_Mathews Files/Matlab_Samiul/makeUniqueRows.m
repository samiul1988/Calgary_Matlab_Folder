function outputVector = makeUniqueRows(inputVector)

% Example:
% for the following vector, 
%                    0                   0   1.000000000000000
%                    0                   0   1.000000000000000
%                    0                   0   1.000000000000000
%                    0   1.000000000000000   1.000000000000000
%                    0   1.000000000000000   0.500000000000000
%                    0   1.000000000000000                   0
%                    0   1.000000000000000                   0
%    0.500000000000000                   0   1.000000000000000
%    0.500000000000000                   0   1.000000000000000
%    0.500000000000000   1.000000000000000   1.000000000000000
%    0.500000000000000   1.000000000000000   0.500000000000000
%    0.500000000000000   1.000000000000000                   0
%    0.500000000000000   1.000000000000000                   0
%    1.000000000000000                   0   1.000000000000000
%    1.000000000000000   1.000000000000000   1.000000000000000
%    1.000000000000000   1.000000000000000   0.500000000000000
%    1.000000000000000   1.000000000000000                   0
%    1.000000000000000   1.000000000000000                   0
%    1.000000000000000                   0   1.000000000000000
%    1.000000000000000                   0   0.500000000000000
%    1.000000000000000                   0                   0
%    1.000000000000000                   0                   0
%    1.000000000000000                   0   0.500000000000000
%    1.000000000000000                   0                   0
%    1.000000000000000                   0                   0
%    1.000000000000000                   0                   0
%    1.000000000000000                   0                   0
%    1.000000000000000                   0                   0
% the output vector will be,
%                    0                   0   1.000000000000000
%                    0   1.000000000000000   1.000000000000000
%                    0   1.000000000000000   0.500000000000000
%                    0   1.000000000000000                   0
%    0.500000000000000                   0   1.000000000000000
%    0.500000000000000   1.000000000000000   1.000000000000000
%    0.500000000000000   1.000000000000000   0.500000000000000
%    0.500000000000000   1.000000000000000                   0
%    1.000000000000000                   0   1.000000000000000
%    1.000000000000000   1.000000000000000   1.000000000000000
%    1.000000000000000   1.000000000000000   0.500000000000000
%    1.000000000000000   1.000000000000000                   0
%    1.000000000000000                   0   1.000000000000000
%    1.000000000000000                   0   0.500000000000000
%    1.000000000000000                   0                   0

tempVector = [];
flag = 0;
for i = 1:size(inputVector,1)
    for j = 1:size(tempVector,1)
        if inputVector(i,:) == tempVector(j,:)
            flag = 1;
        end
    end
    if flag == 0
        tempVector = [tempVector;inputVector(i,:)];
    else
        flag = 0;
    end
end

outputVector = tempVector;
            







