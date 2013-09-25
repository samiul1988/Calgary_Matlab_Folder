function [ROCout,thVec] = roc_for_3Classes(x, threshold)

% HELP:
% Syntax: ROCout=roc(x,thresholds,alpha,verbose)
%
% Input: x - This is a Nx4 data matrix. The first column is the column of the data value;
%            The last three columns are the columns of the classes: correct class (1) and
%            incorrect classes (0).
%        Thresholds - If you want to use all unique values in x(:,1) 
%            then set this variable to 0 or leave it empty; 
%            else set how many unique values you want to use (min=3);
%
% Output: 
%         the ROCplots, the sensitivity and specificity at thresholds; the Area
%         under the curve with Standard error and Confidence interval and
%         comment, Cut-off point for best sensitivity and specificity. 
%         (Optional) the test performances at cut-off point.
%         if ROCout is declared, you will have a struct:
%         ROCout.AUC=Area under the curve (AUC);
%         ROCout.SE=Standard error of the area;
%         ROCout.ci=Confidence interval of the AUC
%         ROCout.co=Cut off point for best sensitivity and sensibility
%         ROCdata.xr and ROCdata.yr points for ROC plot
%
%
% criteria:
%     IF X < h_th THEN decision is ‘class 1’
%     ELSE IF c1 < X < c2 THEN decision is ‘class 2’
%     ELSE decision is ‘class 3’
%
% lu=length(x(x(:,2)==1)); %number of subjects in class 1
% lh=length(x(x(:,2)==0)); %number of subjects in class 1

subjectNumberClass1 = length(x(x(:,2)==1)); %number of subjects in class 1
subjectNumberClass2 = length(x(x(:,3)==1)); %number of subjects in class 2
subjectNumberClass3 = length(x(x(:,4)==1)); %number of subjects in class 3

classVector = [ones(subjectNumberClass1,1); 2*ones(subjectNumberClass2,1);3*ones(subjectNumberClass3,1)]; % make a simplified class vector where 1: class 1, 2: class 2 and 3: class 3

z = sortrows(x,1);

if threshold == 0
    labels = unique(z(:,1)); %find unique values in z
else
    K=linspace(0,1,threshold+1);
    K(1)=[];
    labels=quantile(unique(z(:,1)),K)';
end

labels  = [min(labels)-1; labels;max(labels)+1];

labelNumber = length(labels); %count unique value

index = 1;

for i = 1:labelNumber %- 1
    h_th = labels(i);
    for j = i:labelNumber % i+1:labelNumber
        v_th = labels(j);
        thVec(index,:) = [h_th v_th];
        TP_class1 = length(x(classVector == 1 & x(:,1) <= h_th));
        FN_class1 = length(x(classVector == 1 & x(:,1) > h_th));
        TP_class2 = length(x(classVector == 2 & (h_th < x(:,1)) & (x(:,1)<= v_th)));
        FN_class2 = length(x(classVector == 2 & (x(:,1) <= h_th | x(:,1) > v_th)));
        TP_class3 = length(x(classVector == 3 & x(:,1) > v_th));
        FN_class3 = length(x(classVector == 3 & x(:,1) <= v_th));
        classTPRVector(index,:) = [(TP_class1/(TP_class1 + FN_class1)) (TP_class2/(TP_class2 + FN_class2)) (TP_class3/(TP_class3 + FN_class3))];
        index = index + 1;
    end
end


ROCout = makeUniqueRows(classTPRVector);

% scatter3(ooo(:,1),ooo(:,2),ooo(:,3)),xlabel('x'),ylabel('y'),zlabel('z')



% if hbar<ubar
%     xroc = flipud([1; 1-a(:,2); 0]); %ROC points 
%     yroc=flipud([1; a(:,1); 0]); 
%     labels = flipud(labels);
% else
%     xroc=[0; 1-a(:,2); 1]; yroc=[0; a(:,1); 1]; %ROC points
% end
% 
% Area=trapz(xroc,yroc); %estimate the area under the curve
% 
% %standard error of area
% Area2=Area^2; 
% Q1=Area/(2-Area); 
% Q2=2*Area2/(1+Area);
% V=(Area*(1-Area)+(lu-1)*(Q1-Area2)+(lh-1)*(Q2-Area2))/(lu*lh);
% Serror=realsqrt(V);
% % %confidence interval
% % ci=Area+[-1 1].*(realsqrt(2)*erfcinv(alpha)*Serror);
% % if ci(1)<0; ci(1)=0; end
% % if ci(2)>1; ci(2)=1; end
% % %the best cut-off point is the closest point to (0,1)
% % d=realsqrt(xroc.^2+(1-yroc).^2); %apply the Pitagora's theorem
% % [~,J]=min(d); %find the least distance
% % co=labels(J-1); %Set the cut-off point
% 
% % if verbose
%     %z-test
%     SAUC=(Area-0.5)/Serror; %standardized area
%     p=1-0.5*erfc(-SAUC/realsqrt(2)); %p-value
%     %Performance of the classifier
%     if Area==1
%         str='Perfect test';
%     elseif Area>=0.90 && Area<1
%         str='Excellent test';
%     elseif Area>=0.80 && Area<0.90
%         str='Good test';
%     elseif Area>=0.70 && Area<0.80
%         str='Fair test';
%     elseif Area>=0.60 && Area<0.70
%         str='Poor test';
%     elseif Area>=0.50 && Area<0.60
%         str='Fail test';
%     else
%         str='Failed test - less than chance';
%     end
% % end
% 
% if nargout
%     ROCout.AUC=Area;
%     ROCout.SAUC = SAUC;
%     ROCout.SE=Serror;
%     ROCout.str = str;
%     ROCout.pValue = p;
% %     ROCout.ci=ci;
% %     ROCout.co=co;
%     ROCout.xr=xroc;
%     ROCout.yr=yroc;
% end
