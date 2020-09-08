function [ error] = get_aee( gt,res)
%compute the average endpoint error
%   

[W,H,C] = size(gt);

gt = double(gt);
res = double(res);
error = sqrt(sum(sum((res(:,:,1)-gt(:,:,1)).^2 ))+...
    sum(sum( (res(:,:,2)-gt(:,:,2)).^2)))/(W*H);

end

