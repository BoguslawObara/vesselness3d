%% clear
clc; clear all; close all;

%% path
addpath('./lib')

%% load image
im = imread3d('./im/neuron.tif');

%% normalize
im = double(im); im = (im - min(im(:))) / (max(im(:)) - min(im(:)));

%% 3d vesselness
sigma = 1:1:3;
gamma = 2; 
alpha = 10; 
beta = 5; 
c = 15;
wb = true;

[imv,v,vx,vy,vz,l1,l2,l3] = vesselnessv3d(im,sigma,gamma,alpha,beta,c,wb);

%% plot
figure; imagesc(max(im,[],3)); colormap gray; 
set(gca,'ytick',[]); set(gca,'xtick',[]); axis image; axis tight;

figure; imagesc(max(imv,[],3)); colormap gray; 
set(gca,'ytick',[]); set(gca,'xtick',[]); axis image; axis tight;

%% plot
idx = im>0.3;
iml = im; 
iml(~idx) = [];
vxl = vx; vyl = vy; vzl = vz;
vxl(~idx) = []; vyl(~idx) = []; vzl(~idx) = [];
vxl = vxl.*iml; vyl = vyl.*iml; vzl = vzl.*iml;
[xg,yg,zg] = meshgrid(1:size(im,2),1:size(im,1),1:size(im,3));
xg(~idx) = []; yg(~idx) = []; zg(~idx) = [];

figure;
quiver3(xg,yg,zg,vyl,vxl,vzl);
box on; grid on; camlight; lighting gouraud;
box on; ax = gca; ax.BoxStyle = 'full';
xlim([1 size(im,2)]); ylim([1 size(im,1)]); zlim([1 size(im,3)]);