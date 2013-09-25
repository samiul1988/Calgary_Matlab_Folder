%% only for plotting purpose
clear all
clc

l1 = load('ANN_bootInput_3-1-1_HLS10P1P2.mat');
l2 = load('ANN_bootInput_3-1-1_HLS10P1Ptotal.mat');

l3 = load('ANN_bootInput_6-1-1_HLS10.mat');
l4 = load('ANN_bootInput_6-1-1_HLS4.mat');
l5 = load('ANN_bootInput_6-1-1_HLS6.mat');
l6 = load('ANN_bootInput_6-1-1_HLS8.mat');
l7 = load('ANN_bootInput_6-1-1_HLS12.mat');


figure(1);
x = [4 6 8 10 12];
ebl = [0.001 0.0025 0.0013 0.0008131 0.000393];
ebu = [0.003 0.001 0.0005 0.0002842 0.0003213];

h1 = errorbar(x,[0.8408 0.8999 0.902 0.9048 0.8204],ebl,ebu);

ylim([.8,.92]);



figure(2);
x = [1 2 3];
ebl = [0.003 0.002 0.0008131];
ebu = [0.0037 0.002 0.0002842];

h2 = errorbar(x,[0.8958 0.8258 0.9048],ebl,ebu);

ylim([.5,1]);



