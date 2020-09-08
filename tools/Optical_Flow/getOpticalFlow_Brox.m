function [vx vy]=getOpticalFlow_Brox(im1,im2)
    %% Dong Zhang, Center for Research in Computer Vision, UCF 1/10/2014
    %% Copyright (2014), UCF CRCV
    
    im1 = double(im1);
    im2 = double(im2);
    flow = mex_LDOF(im1,im2);
    vx = flow(:,:,1);
    vy = flow(:,:,2);