function [ error] = get_epe( gt,res)
%compute the average endpoint error
%   

gt = double(gt);
res = double(res);

[ang epe] = flowAngErr(gt (:,:,1), gt(:,:,2), res(:,:,1), res(:,:,2));
error = mean(epe(:));
end

