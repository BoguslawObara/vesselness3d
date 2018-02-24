function imwrite3d(im,path)
%% write multi-plane tiff
delete(path);
for i=1:size(im,3)
    imwrite(im(:,:,i),path,'Compression','none','WriteMode','append');
end

end