function output=do_TransferFunction(input,range,powerOrAmplitude,NFFT)
%%%% input: it is an object containing the fft values of the regions of interest (LGN1,LGN2,V1, LOC1,LOC2,SPA1,SPA2)
%%%% range: how many combinations of transfer functions need to be computed
        %%% all:compute all combinations
        %%% LGN1_V1:only LGN1 to V1
        %%% LGN2_V1:only LGN2 to V1
        %%% V1_LOC1:only V1 to LOC1
        %%% V1_LOC2:only V1 to LOC2
        %%% V1_SPA1:only V1 to SPA1
        %%% V1_SPA2:only V1 to SPA2        
%%%% powerOrAmplitude: Power or Amplitude Spectrum
%%%% NFFT: number of fft input

switch range
    case 'all'
        [output.tf_LGN1_V1, output.ptf_LGN1_V1]= calculateTF(input.V1,input.LGN1,powerOrAmplitude,NFFT);
        [output.tf_LGN2_V1, output.ptf_LGN2_V1]= calculateTF(input.V1,input.LGN2,powerOrAmplitude,NFFT);
        [output.tf_V1_LOC1, output.ptf_V1_LOC1]= calculateTF(input.LOC1,input.V1,powerOrAmplitude,NFFT);
        [output.tf_V1_LOC2, output.ptf_V1_LOC2]= calculateTF(input.LOC2,input.V1,powerOrAmplitude,NFFT);
        [output.tf_V1_SPA1, output.ptf_V1_SPA1]= calculateTF(input.SPA1,input.V1,powerOrAmplitude,NFFT);
        [output.tf_V1_SPA2, output.ptf_V1_SPA2]= calculateTF(input.SPA2,input.V1,powerOrAmplitude,NFFT);
        
    case 'LGN1_V1'
        [output.tf_LGN1_V1, output.ptf_LGN1_V1]= calculateTF(input.V1,input.LGN1,powerOrAmplitude,NFFT);
        
    case 'LGN2_V1'
        [output.tf_LGN2_V1, output.ptf_LGN2_V1]= calculateTF(input.V1,input.LGN2,powerOrAmplitude,NFFT);
        
    case 'V1_LOC1'
        [output.tf_V1_LOC1, output.ptf_V1_LOC1]= calculateTF(input.LOC1,input.V1,powerOrAmplitude,NFFT);
        
    case 'V1_LOC2'
        [output.tf_V1_LOC2, output.ptf_V1_LOC2]= calculateTF(input.LOC2,input.V1,powerOrAmplitude,NFFT);
        
     case 'V1_SPA1'
        [output.tf_V1_SPA1, output.ptf_V1_SPA1]= calculateTF(input.SPA1,input.V1,powerOrAmplitude,NFFT);
        
     case 'V1_SPA2'
        [output.tf_V1_SPA2, output.ptf_V1_SPA2]= calculateTF(input.SPA2,input.V1,powerOrAmplitude,NFFT);
        
end %%% switch
        
end  %%% do_TransferFunction

function [tf,ptf]=calculateTF(numerator,denominator,spectrumType,NFFT)
    tf=numerator./denominator;
    if strcmp(spectrumType,'power')
        oneSidedIndex = ceil((NFFT+1)/2); %%% Exclude half of the fft part
        tf = tf(1:oneSidedIndex);
        ptf=tf.*conj(tf);
        
        if rem(NFFT, 2) % odd nfft excludes Nyquist point
            ptf(2:end) = ptf(2:end)*2;
        else
            ptf(2:end -1) = ptf(2:end -1)*2;
        end
    elseif strcmp(spectrumType,'amplitude')
        ptf=abs(tf);
    end
end %%%% calculateTF