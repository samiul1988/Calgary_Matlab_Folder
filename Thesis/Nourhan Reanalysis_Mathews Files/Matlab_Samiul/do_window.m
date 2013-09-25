function output=do_window(input,window_type)    %%% input is a struct, window_type is a string
output=struct;
signal_type=fieldnames(input); %%% input must be a structure
window_length=length(input.(signal_type{1}));
if strcmp(window_type,'tukeywin')
    window_vector=window(window_type,window_length,0.5);
else 
    window_vector=window(window_type,window_length);
end
for i=1:length(signal_type)
    output.(signal_type{i})=(input.(signal_type{i})) .* window_vector';
end

