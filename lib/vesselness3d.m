function [v,vmax] = vesselness3d(im,sigma,gamma,alpha,beta,c,wb)
%%  vesselness3d - multiscale vessel enhancement filtering
%   
%   REFERENCE:
%       A.F. Frangi, et al., 
%       Multiscale Vessel Enhancement Filtering,
%       Lecture Notes in Computer Science, 1496, 130-137, 1998
%
%   INPUT:
%       im      - 3D gray image,
%       sigma   - Gaussian kernel sigma [1 2 3 ...],
%       gamma   - vesselness parameter,
%       alpha   - vesselness parameter,
%       beta    - vesselness parameter,
%       c       - vesselness parameter,
%       wb      - detect black or white regions.
%
%   OUTPUT:
%       vmax    - vesselness,
%       v       - cell of all vesselness images for each sigma
%
%   AUTHOR:
%       Boguslaw Obara

%% default parameters
if isempty(sigma);  sigma = 1;  end
if isempty(gamma);  gamma = 2;  end
if isempty(alpha);  alpha = 0.5; end
if isempty(beta);   beta = 0.5; end
if isempty(c);      c = 15;     end
if isempty(wb);     wb = true;  end

%% normalize
im = double(im); im = (im - min(im(:))) / (max(im(:)) - min(im(:)));

%% convert image to grey-scale
% im = im2uint8(im); % I assume that Vesselness was defined for grey-scale images

%% convert image to double
im = double(im);

%% start loop over scales
[m,n,o] = size(im);
v = zeros(m,n,o,length(sigma)); 

for i=1:length(sigma)
    
    % second derivatives - Hessian
    [hxx,hyy,hzz,hxy,hxz,hyz] = hessian3d(im,sigma(i));
    
    % normalized derivative - scale
    hxx = power(sigma(i),gamma)*hxx;
    hyy = power(sigma(i),gamma)*hyy;
    hzz = power(sigma(i),gamma)*hzz;
    hxy = power(sigma(i),gamma)*hxy;
    hxz = power(sigma(i),gamma)*hxz;
    hyz = power(sigma(i),gamma)*hyz;

    % eigen values and vectors
    [l1,l2,l3] = ...
        eigen3d_m(hxx,hxy,hxz,hxy,hyy,hyz,hxz,hyz,hzz);

    % sort
    [l1,l2,l3] = eigen_sort3d_m(l1,l2,l3);

    % vesselness
    ralpha = abs(l2)./abs(l3);              % 1 -> plate;   0 -> line  / 0 -> plate;   1 -> line      
    rbeta = abs(l1)./sqrt(abs(l2.*l3));     % 1 -> blob;    0 -> line
    ralpha(isnan(ralpha)) = 0;
    rbeta(isnan(rbeta)) = 0;    
    s = sqrt(l1.^2 + l2.^2 + l3.^2);   
    
    vo =    ( ones(size(im)) - exp(-(ralpha.^2)/(2*alpha^2)) ) .*...
            exp(-(rbeta.^2)/(2*beta^2)) .*...
            ( ones(size(im)) - exp(-(s.^2)/(2*c^2)) );   
        
    % if |l3 > 0| or |l3 < 0|  => vo = 0
    if(wb)
        vo(l3<0) = 0;
    else
        vo(l3>0) = 0;
    end    

    % vo for each scale
    v(:,:,:,i) = vo;

end

%% calculate maximum image over the scales
if length(sigma)>1
    vmax = max(v,[],4);
else
    vmax = v;
end

end