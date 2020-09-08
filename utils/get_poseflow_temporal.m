function [ joints_of, heatmaps_of ] = get_poseflow_temporal(files,FlowConvNet,PoseFlowNet,opt)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
edges= [1,2;1,4;4,5;5,6;1,3;3,7;7,8;8,9;3,13;13,14;14,15;1,10;10,11;11,12];
curIdx = (opt.numFrames+1)/2;
% get joints and heatmaps of all frames
res.heatmaps = {};
res.joints = {};

for i = 1:opt.numFrames
    curimgPath = files{i};
    [joints, heatmaps] = get_joints_heatmaps(curimgPath,FlowConvNet,opt);
    %plot_skeletons( curimgPath,joints,edges,opt );
    res.heatmaps = [res.heatmaps;heatmaps];
    res.joints = [res.joints;joints];

end

warpedHeatmaps = {};
for i = 1:opt.numFrames
    if i == curIdx
        warpedHeatmaps = [warpedHeatmaps;double(res.heatmaps {i})];
    else
        curFrame  = files{i};
        refFrame = files{curIdx};
        curHeatmap = res.heatmaps{i};
        curJoints = res.joints{i};
        [curwarpedHeatmap] = getWarpedHeatmaps(curFrame,refFrame,curHeatmap,curJoints,PoseFlowNet,opt);
        % curjoints =heatmapToJoints(curwarpedHeatmap, opt.numJoints); 
        %plot_skeletons( files{curIdx}, curjoints,edges,opt );
        warpedHeatmaps = [warpedHeatmaps;curwarpedHeatmap];
    end
end

heatmaps_of = zeros(opt.dims(1),opt.dims(2),opt.numJoints,opt.numFrames);
for i = 1:opt.numFrames
    heatmaps_of (:,:,:,i) = warpedHeatmaps{i};
end

heatmaps_of  = mean(heatmaps_of,4);
joints_of = heatmapToJoints(heatmaps_of, opt.numJoints);
%plot_skeletons( files{curIdx},joints_of,edges,opt );
end

%get warped heatmaps through optical flow
function [warpedHeatmap] = getWarpedHeatmaps(curFrame,refFrame,curHeatmap,curJoints,PoseFlowNet,opt)
warpedHeatmap =zeros(opt.dims(1),opt.dims(2),opt.numJoints );

[vx,vy ] =get_pose_flow(curFrame,refFrame,PoseFlowNet);

for i = 1:opt.numJoints 

    %get joint motion
    curx = curJoints(1,i);
    cury = curJoints(2,i);
    curvx = vx(max(floor(curx/1.14),1),max(1,floor(cury/1.14)))*1.14;
    curvy = vy(max(floor(curx/1.14),1),max(1,floor(cury/1.14)))*1.14;
    curvx = sign(curvx)*ceil(abs(curvx));
    curvy = sign(curvy)*ceil(abs(curvy));
    heatmap = curHeatmap(:,:,i);
    curwarpedHeatmap = ones(opt.dims(1),opt.dims(2))*min(heatmap(:));
    for x = 1:opt.dims(1)
        for y = 1:opt.dims(2)
            if x+curvx>0 && x+curvx< opt.dims(1) && ...
                    y+curvy>0 && y+curvy< opt.dims(2) 
                curwarpedHeatmap (x+curvx,y+curvy) = heatmap(x,y);
               % show_heatmap(curwarpedHeatmap )
                %show_heatmap(heatmap)
            end
        end    
    end
    warpedHeatmap(:,:,i) =curwarpedHeatmap;
    
end
end

