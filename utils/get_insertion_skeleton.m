function [jointsOut] = get_insertion_skeleton(joints,edges,internums)
%get joints which have insertion point
jointsOut =[];

for i = 1:size(edges,1)
    startPoint = joints(:,edges(i,1));
    endPoint = joints(:,edges(i,2));
    step = (endPoint-startPoint) /(internums+1);
    jointsOut = horzcat(jointsOut,startPoint);
    for ite = 1:internums
        jointsOut = horzcat(jointsOut,[startPoint(1)+ step(1)*ite;startPoint(2)+ step(2)*ite]);
    end
    jointsOut = horzcat(jointsOut,endPoint);
end


end

