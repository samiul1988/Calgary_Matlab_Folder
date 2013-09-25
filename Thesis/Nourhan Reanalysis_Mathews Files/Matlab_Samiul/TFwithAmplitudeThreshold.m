% This function generates transfer function matrix with varying threshold
% Threshold is applied to the amplitude of the denominator signal (in frequency domain) only
% Threshold criteria:
% 1. obtain the transfer function
% 2. normalize the denominator signal amplitude wrt the maximum signal in the group
% 3. set a threshold (normalized threshold) provided by the user to this normalized denominator signal group
% 4. if abs(normalized denominator signal) < threhsold, discard the corresponnding transfer function value
%     otherwise, consider the value

function [tfunc,ptf,f] = TFwithAmplitudeThreshold(numeratorMatrix, denominatorMatrix,thresholdVector,freqVector,spectrumType,NFFT)
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
            ptf{i}(j,:)=abs(tfunc{i}(j,:));
        end
    end
end

denomMatrixNorm = normalizeMatrix(denominatorMatrix);
% denomMatrixNorm=denominatorMatrix;

%%% Threshold Effect 
for i=1:numberOfPerson
    for j=1:length(thresholdVector)
        for k=1:size(denominatorMatrix,2)
            if abs(denomMatrixNorm(i,k)) <= thresholdVector(j)
                tfunc{i}(j+1,k) = NaN;
                ptf{i}(j+1,k) = NaN;
                f{i}(j+1,k) = NaN;
            end
        end
    end
end