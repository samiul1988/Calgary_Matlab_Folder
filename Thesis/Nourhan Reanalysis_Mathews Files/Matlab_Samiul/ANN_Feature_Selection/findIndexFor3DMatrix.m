function [dim1Ind, dim2Ind, dim3Ind,dimVector] = findIndexFor3DMatrix(matrix3D, logicalExpressionWith3dMatrix)

% Input:
%        matrix3D: 3D matrix
%       logicalExpressionWith3dMatrix: expression associated with matrix3D
% 
% example: matrix3D(:,:,1) = [1 2; 3 4];
%          matrix3D(:,:,2) = [5 6; 7 8];
%          matrix3D(:,:,3) = [9 10; 11 12];
% matrix3D is a 2 by 2 by 3 matrix; 
% here, dim1 = row = 2, dim2 = column = 2, dim3 = 3rd dimension = 3 
% [dim1Ind, dim2Ind, dim3Ind] = findIndexFor3DMatrix(matrix3D, matrix3D == 11) will result in 
% dim1Ind = 2; dim2Ind = 1, dim3Ind = 3, dimVector = [2 1 3]
          
indexVector = find(logicalExpressionWith3dMatrix);

[dim1Ind, dim2Ind, dim3Ind] = ind2sub(size(matrix3D),indexVector');

for i = 1:length(dim1Ind)
    dimVector(i,:)  = [dim1Ind(i) dim2Ind(i) dim3Ind(i)];
end
