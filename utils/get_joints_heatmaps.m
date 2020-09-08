function [joints, heatmaps] = get_joints_heatmaps(imPath,net,opt )
%return heatmaps and joint of input image

img = caffe.io.load_image(imPath);
img = imresize(img,opt.dims );

image{1}=img; 
 
score=net.forward(image);

features = net.blobs('conv5_fusion').get_data();

%get joints and heatmaps
[joints, heatmaps] = processHeatmap(features, opt);
end

