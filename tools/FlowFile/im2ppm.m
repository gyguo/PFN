function im2ppm(imPath)
% png is a string which its filename likes 'xx.png'
% 'xx.ppm' would have the same prefix name

%read file 'xx.png'
image=imread(imPath);

%generete 'xx.ppm'
filename_ppm=strcat(imPath(1:length(png)-4),'.ppm');
imwrite(image,filename_ppm,'ppm');
end