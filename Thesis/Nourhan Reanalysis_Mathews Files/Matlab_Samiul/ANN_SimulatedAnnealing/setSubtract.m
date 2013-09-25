function differenceSet = setSubtract(minuendSet,subtrahendSet) 
% c ? b = a
% minuend (c) ? subtrahend (b) = difference (a)
% Example: 
% c = [22    1     9     2     4    26    22    10    30     2    14    12    24    25     6    16    14    21    22    24 ... 
%       9    22    21     6     4];
% b = [22     2    25    30    16     9     4     6    22    24     2    12    22     9     1    26    14];
% a = [10  6  14    21    24   22  21   4];

for i = 1:length(subtrahendSet)
    index = find(minuendSet == subtrahendSet(i));
    minuendSet(index(1)) = [];
end
differenceSet = minuendSet;

