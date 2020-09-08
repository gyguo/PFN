function [ ix,iy,it ] = get_XYT2(img1Path,img2Path,poseFlowPath,dim )
%get ix,iy,it of two input images

img1 = imread(img1Path);
img2 = imread(img2Path);
img1 = imresize(img1,dim);
img2 = imresize(img2,dim);
img1 = rgb2gray(img1);
img2 = rgb2gray(img2);

h = fspecial('gaussian', [3,3], 1);
img1 = imfilter(img1,h);
img2 = imfilter(img2,h);

d = 1/12.*[-1,8,0,-8,1];
Ix = conv2(img1, d,'same');
Iy = conv2(img1,d', 'same');
It = I2-I1;

h = fspecial('gaussian', [20,20], 1);
img1 = imfilter(img1,h);
img2 = imfilter(img2,h);

ix= conv2(img1,(1/12)*[-1 8 0 -8 1],'same');
iy= conv2(img1,(1/12)*[-1 8 0 -8 1]','same');
it = img2 - img1;

poseFlow =readFlowFile(poseFlowPath);
ix = get_poseFlow_data(ix,poseFlow ,dim);
iy = get_poseFlow_data(iy,poseFlow ,dim);
it = get_poseFlow_data(it,poseFlow ,dim);
end

function output = get_poseFlow_data(input,poseFlow ,dim)

output = zeros(dim(1),dim(2));

for i = 1:dim(1)
    for j = 1:dim(2)
        if poseFlow(i,j,1)~=0 || poseFlow(i,j,2)~=0
            output(i,j) = input(i,j);
        end
    end
end

end

