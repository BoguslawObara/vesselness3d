function [Hxx,Hyy,Hzz,Hxy,Hxz,Hyz] = BOHessianMatrixF3D(im,s)
%% Gaussian filter
img = imgaussfilt3(im,s);
%% First and second order diferentiations
% [Hy,Hx,Hz] = imgradientxyz(img);
% [Hxy,Hxx,Hxz] = imgradientxyz(Hx);
% [Hyy,~,Hyz] = imgradientxyz(Hy);
% [~,~,Hzz] = imgradientxyz(Hz);

%% Create first and second order diferentiations
Hz=gradient3(img,'z');
Hzz=(gradient3(Hz,'z'));
clear Hz;

Hy=gradient3(img,'y');
Hyy=(gradient3(Hy,'y'));
Hyz=(gradient3(Hy,'z'));
clear Hy;

Hx=gradient3(img,'x');
Hxx=(gradient3(Hx,'x'));
Hxy=(gradient3(Hx,'y'));
Hxz=(gradient3(Hx,'z'));
clear Hx;
%% End
end
function D = gradient3(F,option)
[k,l,m] = size(F);
D  = zeros(size(F),class(F)); 

switch lower(option)
case 'x'
    % Take forward differences on left and right edges
    D(1,:,:) = (F(2,:,:) - F(1,:,:));
    D(k,:,:) = (F(k,:,:) - F(k-1,:,:));
    % Take centered differences on interior points
    D(2:k-1,:,:) = (F(3:k,:,:)-F(1:k-2,:,:))/2;
case 'y'
    D(:,1,:) = (F(:,2,:) - F(:,1,:));
    D(:,l,:) = (F(:,l,:) - F(:,l-1,:));
    D(:,2:l-1,:) = (F(:,3:l,:)-F(:,1:l-2,:))/2;
case 'z'
    D(:,:,1) = (F(:,:,2) - F(:,:,1));
    D(:,:,m) = (F(:,:,m) - F(:,:,m-1));
    D(:,:,2:m-1) = (F(:,:,3:m)-F(:,:,1:m-2))/2;
otherwise
    disp('Unknown option')
end
end