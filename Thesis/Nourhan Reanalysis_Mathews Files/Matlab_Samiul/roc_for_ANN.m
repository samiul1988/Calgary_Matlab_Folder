function ROCout = roc_for_ANN(x, threshold)
%
% Syntax: ROCout=roc(x,thresholds,alpha,verbose)
%
% Input: x - This is a Nx2 data matrix. The first column is the column of the data value;
%            The second column is the column of the tag: unhealthy (1) and
%            healthy (0).
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

lu=length(x(x(:,2)==1)); %number of unhealthy subjects
lh=length(x(x(:,2)==0)); %number of healthy subjects
z=sortrows(x,1);
if threshold == 0
    labels = unique(z(:,1)); %find unique values in z
else
    K=linspace(0,1,threshold+1);
    K(1)=[];
    labels=quantile(unique(z(:,1)),K)';
end

ll=length(labels); %count unique value
a=zeros(ll,2); %array preallocation

ubar=mean(x(x(:,2)==1),1); %unhealthy mean value
hbar=mean(x(x(:,2)==0),1); %healthy mean value

for K=1:ll
%     if hbar < ubar
        TP=length(x(x(:,2)==1 & x(:,1)>labels(K)));
        FP=length(x(x(:,2)==0 & x(:,1)>labels(K)));
        FN=length(x(x(:,2)==1 & x(:,1)<=labels(K)));
        TN=length(x(x(:,2)==0 & x(:,1)<=labels(K)));
%     else
%         TP=length(x(x(:,2)==1 & x(:,1)<labels(K)));
%         FP=length(x(x(:,2)==0 & x(:,1)<labels(K)));
%         FN=length(x(x(:,2)==1 & x(:,1)>=labels(K)));
%         TN=length(x(x(:,2)==0 & x(:,1)>=labels(K)));
%     end
    a(K,:)=[TP/(TP+FN) TN/(TN+FP)]; %Sensitivity and Specificity
end

% if hbar<ubar
    xroc = flipud([1; 1-a(:,2); 0]); %ROC points 
    yroc=flipud([1; a(:,1); 0]); 
    labels = flipud(labels);
% else
%     xroc=[0; 1-a(:,2); 1]; yroc=[0; a(:,1); 1]; %ROC points
% end

Area=trapz(xroc,yroc); %estimate the area under the curve

%standard error of area
Area2=Area^2; 
Q1=Area/(2-Area); 
Q2=2*Area2/(1+Area);
V=(Area*(1-Area)+(lu-1)*(Q1-Area2)+(lh-1)*(Q2-Area2))/(lu*lh);
Serror=realsqrt(V);
% %confidence interval
% ci=Area+[-1 1].*(realsqrt(2)*erfcinv(alpha)*Serror);
% if ci(1)<0; ci(1)=0; end
% if ci(2)>1; ci(2)=1; end
% %the best cut-off point is the closest point to (0,1)
% d=realsqrt(xroc.^2+(1-yroc).^2); %apply the Pitagora's theorem
% [~,J]=min(d); %find the least distance
% co=labels(J-1); %Set the cut-off point

% if verbose
    %z-test
    SAUC=(Area-0.5)/Serror; %standardized area
    p=1-0.5*erfc(-SAUC/realsqrt(2)); %p-value
    %Performance of the classifier
    if Area==1
        str='Perfect test';
    elseif Area>=0.90 && Area<1
        str='Excellent test';
    elseif Area>=0.80 && Area<0.90
        str='Good test';
    elseif Area>=0.70 && Area<0.80
        str='Fair test';
    elseif Area>=0.60 && Area<0.70
        str='Poor test';
    elseif Area>=0.50 && Area<0.60
        str='Fail test';
    else
        str='Failed test - less than chance';
    end
% end

if nargout
    ROCout.AUC=Area;
    ROCout.SAUC = SAUC;
    ROCout.SE=Serror;
    ROCout.str = str;
    ROCout.pValue = p;
%     ROCout.ci=ci;
%     ROCout.co=co;
    ROCout.xr=xroc;
    ROCout.yr=yroc;
end
