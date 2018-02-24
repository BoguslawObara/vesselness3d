function [imv,v,vidx,vx,vy,vz,l1,l2,l3] = ...
    vesselnessv3d(im,sigma,gamma,alpha,beta,c,wb)
%%  vesselnessv3d - multiscale vessel enhancement filtering with vectors
%   
%   REFERENCE:
%       B. Obara, M. Fricker, D. Gavaghan and V. Grau, 
%       Contrast-independent curvilinear structure detection in biomedical 
%       images, IEEE Transactions on Image Processing, 21, 5, 2572-2581, 2012, 
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
%       imv     - vesselness,
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
vxt = zeros(m,n,o,length(sigma)); 
vyt = zeros(m,n,o,length(sigma));
vzt = zeros(m,n,o,length(sigma));
vx = zeros(m,n,o); 
vy = zeros(m,n,o);
vz = zeros(m,n,o);
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
    [l1,l2,l3,v1,v2,v3,v4,v5,v6,v7,v8,v9] = ...
        eigen3d_m(hxx,hxy,hxz,hxy,hyy,hyz,hxz,hyz,hzz);

    % sort
    [l1,l2,l3,v1,v2,v3,v4,v5,v6,v7,v8,v9] = eigen_sort3d_m(l1,l2,l3,v1,v2,v3,v4,v5,v6,v7,v8,v9);
    
    %    
    vxt(:,:,:,i) = v1; 
    vyt(:,:,:,i) = v2;
    vzt(:,:,:,i) = v3;   

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
    [imv,vidx] = max(v,[],4);
    for i=1:m
        for j=1:n
            for k=1:o
                vx(i,j,k) = vxt(i,j,k,vidx(i,j,k)); 
                vy(i,j,k) = vyt(i,j,k,vidx(i,j,k));
                vz(i,j,k) = vzt(i,j,k,vidx(i,j,k));                
            end
        end
    end
else
    imv = v;
    vidx = ones(size(imv));
    vx = vxt(:,:,:,1);
    vy = vyt(:,:,:,1);
    vz = vzt(:,:,:,1);
end

end