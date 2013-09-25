%%
clear all;
clc;
close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

C1EC=get_input; %%%% Get the input data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Define time and frequency vectors and other parameters %%%%%%%%%%%

T=1.5; %%%%% Sampling Time
L= 160; %%%% Signal Length
NFFT = 256; %%%%%% Number of FFT point 
time_vector = (0:L-1)*T;
frequency_vector = 0:1/(L*T):1/(2*T); %%% for normal FFT
frequency_vector_NFFT = 0:1/(NFFT*T):1/(2*T); %%% for NFFT-point FFT
L_NFFT=length(frequency_vector_NFFT);
% frequency_vector = 0:1/(L*T):(160 - 1) / (2* 160 * 1.25);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure;
% plot(time_vector,[C1EC.LGN C1EC.V1 C1EC.LOC1 C1EC.LOC2 C1EC.SPA1 C1EC.SPA2]);

%%%% Removing DC components 
C1ECnoDC=remove_DC(C1EC);
% figure;
% plot(time_vector,[C1ECnoDC.LGN C1ECnoDC.V1 C1ECnoDC.LOC1 C1ECnoDC.LOC2 C1ECnoDC.SPA1 C1ECnoDC.SPA2]);

%%%% windowing 
window_type='tukeywin';
C1ECnoDCwin=do_window(C1ECnoDC,window_type);
%%%% fft calculation 
C1ECnoDCfft=do_fft(C1ECnoDCwin,NFFT);
% figure;
% plot(frequency_vector_NFFT,[abs(C1ECnoDCfft.LGN(1:length(frequency_vector_NFFT))) abs(C1ECnoDCfft.V1(1:length(frequency_vector_NFFT)))])

% %%% Transfer function (normal) %%%%
% C1EC_tf_LGN_V1=(C1ECnoDCfft.V1)./(C1ECnoDCfft.LGN);
% figure;
% plot(frequency_vector_NFFT,abs(C1EC_tf_LGN_V1(1:length(frequency_vector_NFFT))))

% % % % % %%% Transfer function (with thresholding) %%%%
% % % % % C1EC_tf_LGN_V1=threshold_tf(C1ECnoDCfft.V1,C1ECnoDCfft.LGN,20);
% % % % % figure;
% % % % % plot(frequency_vector_NFFT,abs(C1EC_tf_LGN_V1(1:length(frequency_vector_NFFT))))

% figure;
% plot(frequency_vector_NFFT,abs([C1ECnoDCfft.V1(1:L_NFFT) C1ECnoDCfft.LGN(1:L_NFFT)]))
% legend('V1','LGN')
LGNmax=max(abs(C1ECnoDCfft.LGN))
LGNmin=min(abs(C1ECnoDCfft.LGN))
V1max=max(abs(C1ECnoDCfft.V1))
V1min=min(abs(C1ECnoDCfft.V1))
%%

%%% transfer function

tf_C1EC_LGN_V1= C1ECnoDCfft.V1./ C1ECnoDCfft.LGN;
%%% generate power spectrum
P_tf_C1EC_LGN_V1= tf_C1EC_LGN_V1.*conj(tf_C1EC_LGN_V1); %%%  the division removes the effect of signal length on fft (X=fft(x,nfft)/length(x); then Px=X.*conj(X))
% P_tf_C1EC_LGN_V1 = abs(tf_C1EC_LGN_V1);

if rem(NFFT, 2) % odd nfft excludes Nyquist point
  P_tf_C1EC_LGN_V1(2:end) = P_tf_C1EC_LGN_V1(2:end)*2;
else
  P_tf_C1EC_LGN_V1(2:end -1) = P_tf_C1EC_LGN_V1(2:end -1)*2;
end

power=zeros(size(P_tf_C1EC_LGN_V1));

a=find(frequency_vector_NFFT<=0.1);
b=find(frequency_vector_NFFT>0.1 & frequency_vector_NFFT<=0.2);
c=find(frequency_vector_NFFT>0.2);


power(a(1))=median(P_tf_C1EC_LGN_V1(a));
power(b(1))=median(P_tf_C1EC_LGN_V1(b));
power(c(1))=median(P_tf_C1EC_LGN_V1(c));

plot(frequency_vector_NFFT,power(1:length(frequency_vector_NFFT)))

% threshold=abs(min(C1ECnoDCfft.LGN))+10;
% tf_C1EC_LGN_V1(find(abs(C1ECnoDCfft.LGN)<threshold))=C1ECnoDCfft.V1(find(abs(C1ECnoDCfft.LGN)<threshold));
% for i=1:length(C1ECnoDCfft.LGN)
%     if abs(C1ECnoDCfft.LGN(i))<threshold
%         tf_C1EC_LGN_V1(i)=C1ECnoDCfft.V1(i);
%     end
% end
    
% P_tf_C1EC_LGN_V1= tf_C1EC_LGN_V1.*conj(tf_C1EC_LGN_V1);
 A_tf_C1EC_LGN_V1 = abs(tf_C1EC_LGN_V1);


%%%%%% taking the median power %%%%%
% frequency_vector_NFFT(129)=[];


figure;
frequency_vector_NFFT(end)=[];

plot(frequency_vector_NFFT,A_tf_C1EC_LGN_V1(1:length(frequency_vector_NFFT)))

