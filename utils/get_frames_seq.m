function [ files ] = get_frames_seq(curimg,numFrames)
%get sequence files names

files={};
numSide = (numFrames-1)/2;
for i = -numSide:numSide
    files = [files; get_file_name(curimg,i)];
end

end

%
function fileName = get_file_name(curName,dis)

num = str2num(curName(end-11:end-4))+dis;
name = num2str(num);
while numel(name)<8
    name=['0' name];
end
fileName = [curName(1:end-12) name '.jpg'];
end