function output=do_fft(input,NFFT)

output=struct;
signal_type=fieldnames(input); %%% input must be a structure

for i=1:length(signal_type)
    output.(signal_type{i})=fft(input.(signal_type{i}),NFFT) / NFFT;
end

