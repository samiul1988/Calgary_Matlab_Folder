clear all
clc

data1 = load('AzValueFor1HL.mat');
data2 = load('AzValueFor2HL.mat');
data3 = load('AzValueFor3HL.mat');

for i = 1:size(data3.meanAz,2)
    for j = 1:size(data3.meanAz,3)
        for k = 1:size(data3.meanAz,4)
            kk(i,j,k) = data3.meanAz(1,i,j,k);
        end
    end
end
nNeuron1HL = find(data1.meanAz >= 0.95 * max(data1.meanAz)) 
Az1HL = data1.meanAz(nNeuron1HL)

[~,~,~,nNeuron2HL] = findIndexFor3DMatrix(data2.vv, data2.vv >= 0.95 * max(max(data2.vv)));
nNeuron2HL = nNeuron2HL(:,1:2)
for i = 1:size(nNeuron2HL,1)
    Az2HL(i,1) = data2.vv(nNeuron2HL(i,1),nNeuron2HL(i,2));
end
Az2HL

[~,~,~,nNeuron3HL] = findIndexFor3DMatrix(kk, (kk >= 0.86 & kk < 0.87))

for i = 1:size(nNeuron3HL,1)
    Az3HL(i,1) = kk(nNeuron3HL(i,1),nNeuron3HL(i,2),nNeuron3HL(i,3));
end
Az3HL





