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

[imv,v] = vesselness3d(im,sigma,gamma,alpha,beta,c,wb);

%% plot
figure; imagesc(max(im,[],3)); colormap gray; 
set(gca,'ytick',[]); set(gca,'xtick',[]); axis image; axis tight;

figure; imagesc(max(imv,[],3)); colormap gray; 
set(gca,'ytick',[]); set(gca,'xtick',[]); axis image; axis tight;