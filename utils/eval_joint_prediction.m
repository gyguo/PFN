%evaluation function and plotting
function score = eval_joint_prediction(gt_joints,pred_joints, thresh)

%scale joints
gt_joints = 0.5*(gt_joints-1)+1;
pred_joints = 0.5*(pred_joints-1)+1;

%compute distance
distance = squeeze(sqrt(sum((pred_joints-gt_joints).^2)))';

score = zeros(numel(thresh),15);
count = 1;
for t=thresh
    score(count,:) = mean(distance<=t);
    count = count + 1;
end

end