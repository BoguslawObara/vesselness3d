function im = imread3d(path,n)
%% read multi-plane tif
info = imfinfo(path);
nf = length(info);
if nargin>1
    nf = n;
end

im = zeros(info(1).Height,info(1).Width,nf);
for i=1:nf
    im(:,:,i) = imread(path,i);
end

end