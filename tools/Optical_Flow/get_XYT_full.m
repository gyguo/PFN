function [ ix,iy,it ] = get_XYT_full(img1Path,img2Path,dim )
%get ix,iy,it of two input images

img1 = imread(img1Path);
img2 = imread(img2Path);
img1 = imresize(img1,dim);
img2 = imresize(img2,dim);
img1 = rgb2gray(img1);
img2 = rgb2gray(img2);

% ix = conv2(img1,[1 -1]);
% iy = conv2(img1,[1; -1]);
% it= img2-img1;

h = fspecial('gaussian', [20,20], 1);
img1 = imfilter(img1,h);
img2 = imfilter(img2,h);

ix= conv2(img1,(1/12)*[-1 8 0 -8 1],'same');
iy= conv2(img1,(1/12)*[-1 8 0 -8 1]','same');
it = conv2(img1, 0.25*ones(2),'same') + conv2(img2, -0.25*ones(2),'same');
end

