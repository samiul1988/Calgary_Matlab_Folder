%% only for plotting purpose
clear a b;



c=27;
spa1=abs(SPA1(c,:));
v1=abs(V1(c,:));
a1=abs(tfMatrix{c}(1,:));
b1=freqMatrix{c}(1,:);

a2=abs(tfMatrix{c}(2,:));
b2=freqMatrix{c}(2,:);

for i=1:length(a2)
if isnan(a2(i))
a2(i)=0;
b2(i)=0;
end
end
figure; 
% subplot 411, plot(b1,spa1);
% subplot 412, plot(b1,v1);
% subplot 413, plot(b1,a1);  % hold on; plot(b1,a2,'r');
% subplot 414, plot(b1,a2)

%18.7159
subplot 221, plot(b1,spa1),xlabel('Frequency (Hz)'),ylabel('Amplitude'), title('SPA1'),xlim([0 .3]);
subplot 223, plot(b1,v1),xlabel('Frequency (Hz)'),ylabel('Amplitude'), title('V1'),xlim([0 .3]),hold on; plot([0 .3],[18.7159*2 18.7159*2],'r--');hold off;
subplot(2,2,[2;4]), plot(b1,a1),xlabel('Frequency (Hz)'),ylabel('Gain'), title('Transfer function without threshold'),xlim([0 .3]);hold on; plot(b1,a2,'r');hold off;
% subplot 224, plot(b1,a2), axis([0 .3 0 6]),xlabel('Frequency (Hz)'),ylabel('Gain'), title('Transfer function with threshold');

% subplot 221, plot(b1,spa1),xlabel('Frequency (Hz)'),ylabel('Amplitude'), title('SPA1'),xlim([0 .3]);
% subplot 223, plot(b1,v1),xlabel('Frequency (Hz)'),ylabel('Amplitude'), title('V1'),xlim([0 .3]),hold on; plot([0 .3],[18.7159*2 18.7159*2],'r--');hold off;
% subplot 222, plot(b1,a1),xlabel('Frequency (Hz)'),ylabel('Gain'), title('Transfer function without threshold'),xlim([0 .3]);
% subplot 224, plot(b1,a2), axis([0 .3 0 6]),xlabel('Frequency (Hz)'),ylabel('Gain'), title('Transfer function with threshold');
% 
% plot(b1,a1,'r')
% hold on;
% plot(b1,a2)
