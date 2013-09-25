function output=remove_DC(input)
output=struct;
signal_type=fieldnames(input); %%% input must be a structure
%%%  DC removal %%%
for i=1:length(signal_type)
    output.(signal_type{i})=input.(signal_type{i})-mean(input.(signal_type{i}));
%     output=setfield(output,signal_type{i},((getfield(input,signal_type{i})-mean((getfield(input,signal_type{i})));
end
