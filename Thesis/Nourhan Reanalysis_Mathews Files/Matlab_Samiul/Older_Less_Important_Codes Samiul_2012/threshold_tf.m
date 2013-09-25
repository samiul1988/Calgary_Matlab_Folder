function tf=threshold_tf(tf_numerator_vector,tf_denominator_vector, threshold_level)

denom=zeros(1,length(tf_denominator_vector));
tf=zeros(1,length(tf_denominator_vector));

%%%%% method 1
% for i=1:length(tf_denominator_vector)
%     if abs(tf_denominator_vector(i))<threshold_level
%         if i==1
%             denom(i)=mean(tf_denominator_vector(i:i+2));
%         elseif i==length(tf_denominator_vector)
%             denom(i)=mean(tf_denominator_vector(i-2:i));
%         else 
%             denom(i)=mean(tf_denominator_vector(i-1:i+1));
%         end
%     else 
%         denom(i)=tf_denominator_vector(i);
%     end
%     tf_denominator_vector(i)=denom(i);
%     tf(i)=tf_numerator_vector(i)/denom(i);
% end

%%%% method 2
% tf_denominator_vector=smooth(tf_denominator_vector,3);
% % tf_numerator_vector=smooth(tf_numerator_vector,3);
% for i=1:length(tf_denominator_vector)
%     if abs(tf_denominator_vector(i))<threshold_level
%         if i==1
%             denom(i)=mean(tf_denominator_vector(i:i+2));
%         elseif i==length(tf_denominator_vector)
%             denom(i)=mean(tf_denominator_vector(i-2:i));
%         else 
%             denom(i)=mean(tf_denominator_vector(i-1:i+1));
%         end
%     else 
%         denom(i)=tf_denominator_vector(i);
%     end
% %     tf_denominator_vector(i)=denom(i);
%     tf(i)=tf_numerator_vector(i)/denom(i);
% end


for i=1:length(tf_denominator_vector)
    if abs(tf_denominator_vector(i))<threshold_level
        denom(i)=1;
    else 
        denom(i)=tf_denominator_vector(i);
    end
%     tf_denominator_vector(i)=denom(i);
    tf(i)=tf_numerator_vector(i)/denom(i);
end
