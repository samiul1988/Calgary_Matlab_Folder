%% Smooth ROC Plot (Only for plotting) 

%% Without Threshold
clear all;
clc
close all;

load('LGNtoV1_without_threshold.mat');

P1_Ptotal_xr = P1_Ptotal_ROC.xr;
P1_Ptotal_yr = P1_Ptotal_ROC.yr;

P2_Ptotal_xr = P2_Ptotal_ROC.xr;
P2_Ptotal_yr = P2_Ptotal_ROC.yr;

P3_Ptotal_xr = P3_Ptotal_ROC.xr;
P3_Ptotal_yr = P3_Ptotal_ROC.yr;

P1_P2_xr = P1_P2_ROC.xr;
P1_P2_yr = P1_P2_ROC.yr;

P1_P3_xr = P1_P3_ROC.xr;
P1_P3_yr = P1_P3_ROC.yr;

P2_P3_xr = P2_P3_ROC.xr;
P2_P3_yr = P2_P3_ROC.yr;

%%%% 
x = 0:0.01:1;
p1pt_y=P1toPtotal_model(x);
p2pt_y=P2toPtotal_model(x);
p3pt_y=P3toPtotal_model(x);
p1p2_y=P1toP2_model(x);
p1p3_y=P1toP3_model(x);
p2p3_y=P2toP3_model(x);

plot(x,[p1pt_y p2pt_y p3pt_y p1p2_y p1p3_y p2p3_y]);hold on;
plot([0 1],[0 1],'g');
axis([0 1 0 1]);
legend('P_1/P_total','P_2/P_total','P_3/P_total','P_1/P_2','P_1/P_3','P_2/P_3');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% With Threshold
clear all;
clc;
close all;

load('V1toSPA1_withThreshold_P1byPtotal.mat');

X1 = plotRoc(1).xr;
Y1 = plotRoc(1).yr;
X2 = plotRoc(2).xr;
Y2 = plotRoc(2).yr;
X3 = plotRoc(3).xr;
Y3 = plotRoc(3).yr;
X4 = plotRoc(4).xr;
Y4 = plotRoc(4).yr;
X5 = plotRoc(5).xr;
Y5 = plotRoc(5).yr;
X6 = plotRoc(6).xr;
Y6 = plotRoc(6).yr;
X7 = plotRoc(7).xr;
Y7 = plotRoc(7).yr;
X8 = plotRoc(8).xr;
Y8 = plotRoc(8).yr;
X9 = plotRoc(9).xr;
Y9 = plotRoc(9).yr;
X10 = plotRoc(10).xr;
Y10 = plotRoc(10).yr;
X11 = plotRoc(11).xr;
Y11 = plotRoc(11).yr;

% for i=1:length(plotRoc)
%     X(i,:) = plotRoc(i).xr;
%     Y(i,:) = plotRoc(i).yr;
% end

x = 0:0.01:1;
p1_y=T1model(x);
p2_y=T2model(x);
p3_y=T3model(x);
p4_y=T4model(x);
p5_y=T5model(x);
p6_y=T6model(x);
p7_y=T7model(x);
p8_y=T8model(x);
p9_y=T9model(x);
p10_y=T10model(x);
p11_y=T11model(x);

plot(x,[p1_y p2_y p3_y p4_y p5_y p6_y p7_y p8_y p9_y p10_y p11_y]);hold on;
plot([0 1],[0 1],'g');
axis([0 1 0 1]);
legend('Without Threshold','Th = 0.01','Th = 0.02','Th = 0.03','Th = 0.04','Th = 0.05','Th = 0.06','Th = 0.07','Th = 0.08','Th = 0.09','Th = 0.10');




