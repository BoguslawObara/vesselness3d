function [hxx,hyy,hzz,hxy,hxz,hyz] = hessian3d(im,s)

%% Gaussian 2nd derivatives
[gxx,gyy,gzz,gxy,gxz,gyz] = gaussian2nd3d(s);

%% Hessian
hxx = imfilter(im,gxx,'conv','same','replicate');
hyy = imfilter(im,gyy,'conv','same','replicate');
hzz = imfilter(im,gzz,'conv','same','replicate');
hxy = imfilter(im,gxy,'conv','same','replicate');
hxz = imfilter(im,gxz,'conv','same','replicate');
hyz = imfilter(im,gyz,'conv','same','replicate');

end