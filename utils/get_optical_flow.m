function [vx,vy ] = get_optical_flow(im1,im2 )
%get optical flow between two frames

% load the two frames
im1 = im2double(im1);
im2 = im2double(im2);
% set optical flow parameters (see tools/Optical_Flow/Coarse2FineTwoFrames.m for the definition of the parameters)
alpha = 0.012;
ratio = 0.75;
minWidth = 20;
nOuterFPIterations = 7;
nInnerFPIterations = 1;
nSORIterations = 30;

para = [alpha,ratio,minWidth,nOuterFPIterations,nInnerFPIterations,nSORIterations];
[vx,vy,~] = Coarse2FineTwoFrames(im1,im2,para);
end

