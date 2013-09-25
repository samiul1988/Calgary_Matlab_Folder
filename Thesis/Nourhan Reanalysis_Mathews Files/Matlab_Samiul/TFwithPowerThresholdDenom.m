% This function generates transfer function matrix with varying threshold
% Threshold is applied to the power of the denominator signals without normalizaing w.r.t to group maximum (in frequency domain)
% Threshold criteria:
% 1. obtain the transfer function
% 2. obtain average power of the denominator signals individually (no normalization)
% 3. set thresholds for denominator signal power provided by the user  
% 4. square root the threshold value to apply it in the amplitude spectrum of the denominator signals
% 5. if abs(denominator signal) < denomThereshold
%     discard the corresponnding transfer function value
%    else
%         consider the transfer function
%    end

function [tfunc,ptf,f] = TFwithPowerThresholdDenom(numeratorMatrix, denominatorMatrix,thresholdVector,freqVector,spectrumType,NFFT)
% numeratorMatrix: ('number of subjects' by 'one sided spectrum length') matrix for numerator signal of the transfer function (TF = numerator ./ denominator )
% denominatorMatrix: ('number of subjects' by 'one sided spectrum length') matrix for denominator signal of the transfer function (TF = numerator ./ denominator )
% thresholdVector: variable threshold values
% freqVector: one sided frequency vector
% spectrumType: 'power' or 'amplitude' spectrum
% NFFT: number of fft points

numberOfPerson = size(numeratorMatrix,1);

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
        thresholdDenom = computeThreshold(denominatorMatrix(i,:), thresholdVector(j)); 
        for k = 1:size(denominatorMatrix,2)
            if abs(denominatorMatrix(i,k)) <= thresholdDenom
                tfunc{i}(j+1,k) = NaN;
                ptf{i}(j+1,k) = NaN;
                f{i}(j+1,k) = NaN; % discard that particular frequency information
            end % if
        end % for k
    end % for j
end % for i


function thDenomSignal = computeThreshold(denomSignal,thresholdValue) 
% Obtain Thresholds for numerator and denominator signals

pDenomSignal = (denomSignal .* conj(denomSignal));
pDenomSignal(2:end-1) = 2 * pDenomSignal(2:end-1);
pAvgDenomSignal = sum(pDenomSignal);
thDenomSignal = sqrt(thresholdValue * pAvgDenomSignal);
