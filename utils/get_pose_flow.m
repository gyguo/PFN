function [vx,vy ] = get_pose_flow(im1,im2, PoseFlowNet)
%get optical flow between two frames
im1= imread(im1);
im2= imread(im2);
mean_rgb = [53.0757,61.8645, 58.2703];
im1 = prepare_caffe_image(im1,[224 224],mean_rgb );
im2 = prepare_caffe_image(im2,[224 224],mean_rgb );
image{1}=im1; 
image{2}=im2; 
 
score=PoseFlowNet.forward(image);
score = score{1};

data = PoseFlowNet.blobs('af1_conv_1').get_data();
map = data(:,:,1);
map = double(map);
vx = permute(map, [2, 1]);

data = PoseFlowNet.blobs('af2_conv_1').get_data();
map=data(:,:,1);
map=double(map);
vy = permute(map, [2, 1]);
end

