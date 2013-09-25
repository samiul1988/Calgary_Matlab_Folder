function outputMatrix=normalizeMatrix(inputMatrix)

% normalize inputMatrix w.r.t. the maximum value in the group
outputMatrix = double(inputMatrix)/max(max(double(abs(inputMatrix))));


% for i=1:size(inputMatrix,1)
%     outputMatrix(i,:) = double(inputMatrix(i,:))/max(double(abs(inputMatrix(i,:))));
% end
