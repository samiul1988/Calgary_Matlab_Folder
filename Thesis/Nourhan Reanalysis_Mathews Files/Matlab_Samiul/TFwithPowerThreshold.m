% This function generates transfer function matrix with varying threshold
% Threshold is applied to the power of the numerator and denominator signals without normalizaing w.r.t to group maximum (in frequency domain)
% Threshold criteria:
% 1. obtain the transfer function
% 2. obtain average power of the numerator and denominator signals individually (no normalization)
% 3. set thresholds for both numerator and denominator signal power provided by the user  
% 4. square root the threshold value to apply it in the amplitude spectrum of the numerator and denominator signals
% 5. if abs(denominator signal) < denomThereshold
%     discard the corresponnding transfer function value
%    else
%     if abs(numerator signal) < numThereshold
%         make transfer function of that frequency = 0
%     else
%         consider the transfer function
%     end
%   end

function [tfunc,ptf,f] = TFwithPowerThreshold(numeratorMatrix, denominatorMatrix,thresholdStruct,freqVector,spectrumType,NFFT)
% numeratorMatrix: ('number of subjects' by 'one sided spectrum length') matrix for numerator signal of the transfer function (TF = numerator ./ denominator )
% denominatorMatrix: ('number of subjects' by 'one sided spectrum length') matrix for denominator signal of the transfer function (TF = numerator ./ denominator )
% thresholdStruct: struct that contains variable threshold value ranges for both numerator and denominator signal
% freqVector: one sided frequency vector
% spectrumType: 'power' or 'amplitude' spectrum
% NFFT: number of fft points

numberOfPerson = size(numeratorMatrix,1);

%%% generate thresholdVector
k = 1;
for i =1:length(thresholdStruct.thresholdValueNum)
    for j =1:length(thresholdStruct.thresholdValueDenom)
        thresholdVector(k,:) = [thresholdStruct.thresholdValueNum(i) thresholdStruct.thresholdValueDenom(j)];
        k = k + 1;
    end 
end

%%% Computing transfer function and power spectrum and replicate it for length(thresholdVector) + 1 times (first one is without threshold)
for i=1:numberOfPerson
    for j=1:length(thresholdVector)+1
        tfunc{i}(j,:) = numeratorMatrix(i,:) ./ denominatorMatrix(i,:);
        f{i}(j,:) = freqVector;
        if strcmp(spectrumType,'power')
            ptf{i}(j,:) = tfunc{i}(j,:) .* conj(tfunc{i}(j,:));
            if rem(NFFT, 2) % odd nfft excludes Nyquist point
                ptf{i}(j,2:end) = ptf{i}(j,2:end)*2;
            else
                ptf{i}(j,2 : end -1) = ptf{i}(j,2:end -1)*2;
            end
        elseif strcmp(spectrumType,'amplitude')
            ptf{i}(j,:) = abs(tfunc{i}(j,:));
        end
    end
end

%%% Threshold based on Average Power
%%% Two threshold approach

%%% Threshold Effect 
for i = 1:numberOfPerson
    for j = 1:length(thresholdVector)
        [thresholdNum, thresholdDenom] = computeThreshold(numeratorMatrix(i,:), denominatorMatrix(i,:), thresholdVector(j,:)); 
        for k = 1:size(denominatorMatrix,2)
            if abs(denominatorMatrix(i,k)) <= thresholdDenom
                tfunc{i}(j+1,k) = NaN;
                ptf{i}(j+1,k) = NaN;
                f{i}(j+1,k) = NaN; % discard that particular frequency information
            else 
                if abs(numeratorMatrix(i,k)) <= thresholdNum
                    tfunc{i}(j+1,k) = 0;
                    ptf{i}(j+1,k) = 0;
                end % if
            end % if
        end % for k
    end % for j
end % for i


function [thNumSignal, thDenomSignal] = computeThreshold(numSignal, denomSignal,thresholdValues) 
% Obtain Thresholds for numerator and denominator signals
% thresholdValues: 1 by 2 vector which contains numerical thresholds for the numerator and denominator
 
pNumSignal = (numSignal .* conj(numSignal));
pDenomSignal = (denomSignal .* conj(denomSignal));

pNumSignal(2:end-1 ) = 2 * pNumSignal(2:end-1);
pDenomSignal(2:end-1) = 2 * pDenomSignal(2:end-1);

pAvgNumSignal = sum(pNumSignal);
pAvgDenomSignal = sum(pDenomSignal);

thNumSignal = sqrt(thresholdValues(1) * pAvgNumSignal);
thDenomSignal = sqrt(thresholdValues(2) * pAvgDenomSignal);
