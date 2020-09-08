function [vx,vy ] = generate_poseflow(imgPath,joints1,joints2,opt )
%generate pose flow groundtruth
[h,w,~] = size(imread(imgPath));
vx = zeros(opt.dims(1) ,opt.dims(2));
vy= zeros(opt.dims(1) ,opt.dims(2));

xRatio = opt.dims(1)/w;
yRatio = opt.dims(2)/h;
for i =1:size(joints1,2)
    if joints1(1,i)<=w && joints1(2,i)<=h
        vx(max(1,floor(joints1(2,i)*yRatio)),max(1,floor(joints1(1,i)*xRatio))) = (joints2(1,i)-joints1(1,i))*xRatio;
        vy(max(1,floor(joints1(2,i)*yRatio)),max(1,floor(joints1(1,i)*xRatio))) = (joints2(2,i)-joints1(2,i))*yRatio;
    end
end

x1 = min(joints1(1,:))*xRatio;
x2 = max(joints1(1,:))*xRatio;
y1 = min(joints1(2,:))*yRatio;
y2 = max(joints1(2,:))*yRatio;

area1 = sqrt((y2-y1)*(x2-x1));
opt.kernelSize = max(1,floor(area1/7.5));
if rem(opt.kernelSize,2)==0
    opt.kernelSize = opt.kernelSize +1;
end


vx = flowDilated(vx,opt);
vy = flowDilated(vy,opt);
end

%special dialated for flow data
function flowDilated = flowDilated(flow,opt)

kernel=zeros(opt.kernelSize,opt.kernelSize);
for x = 1:opt.kernelSize
    kernel(x,(opt.kernelSize+1)/2)=1;
    kernel((opt.kernelSize+1)/2,x)=1; 
end  

%dialate positive part
posFlow = zeros(opt.dims(1) ,opt.dims(2));
for i=1:opt.dims(1)
    for j = 1:opt.dims(2)
        if flow(i,j)>0
            posFlow(i,j) = flow(i,j);
        end
    end
end
posFlow=imdilate(posFlow,kernel);

%dialate negative part
negFlow = zeros(opt.dims(1) ,opt.dims(2));
for i=1:opt.dims(1)
    for j = 1:opt.dims(2)
        if flow(i,j)<0
            negFlow(i,j) = flow(i,j)*-1;
        end
    end
end
negFlow=imdilate(negFlow,kernel);

flowDilated = posFlow - negFlow;
end
  

