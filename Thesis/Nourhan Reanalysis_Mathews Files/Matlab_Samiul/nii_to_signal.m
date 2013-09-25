function y = nii_to_signal(mainImage,mask)

y=zeros(1,size(mainImage.img,4));
m = mask.img;
m=double(m);

for i=1:size(mainImage.img,4)
    Im=mainImage.img(:,:,:,i);
    Im=double(Im);
    sig=m.*Im;
%     sig=reduce3Dmatrix(sig);
    y(i)= mean(sig(find(sig~=0)));
end