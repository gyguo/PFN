clc;
clear;

%set path
rootPath = rootPath = '/home/ggy/code/PFN';
cmudbDSPath =  fullfile(rootPath,'data','cmudbDS.mat');
addpath(genpath(fullfile(rootPath,'tools','panoptic-toolbox')));
addpath(genpath(fullfile(rootPath,'tools','Optical_Flow')));
addpath(genpath(fullfile(rootPath,'utils')));
txtPath = fullfile(rootPath,'data','caffe_txt');
savePath = fullfile(rootPath,'data','PoseFlow-DS-448');

opt.dims = [448,448];%size of frames
opt.internums = 200;%number of iterated points
opt.kernelSize =17; %kernel size of dilated
opt.edges=[1,2;1,4;4,5;5,6;1,3;3,7;7,8;8,9;3,13;13,14;14,15;1,10;10,11;11,12];

cmudbDS = load(cmudbDSPath);
cmudbDS = cmudbDS.cmudbDS;
%index of traindata and test data

%% generate tain txt
dataListTxt= fullfile(txtPath,'poseflow_DS448.list');
splitTxt = fullfile(txtPath,'splitDS448.list');
fid1 = fopen(dataListTxt ,'wt');
fid2 = fopen(splitTxt ,'wt');
    
for i =1:numel(cmudbDS.set)
    fprintf('train:%d/%d\n',i,numel(cmudbDS.set));
    curgt = cmudbDS.gt{i}.joints;
    curnames = cmudbDS.gt{i}.names;
    for im = 1:cmudbDS.nFrames(i)-1
        
        curFramePath = fullfile(cmudbDS.framesPath,curnames{im});
        nextFramePath = fullfile(cmudbDS.framesPath,curnames{im+1});
        
        %set path for generated data
        curPoseFlowPath = fullfile(savePath,'gt',curnames{im} );
        curPoseFlowPath = [curPoseFlowPath(1:end-4) '.mat'];
        curppmPath = fullfile(savePath,'Frames',curnames{im} );
        curppmPath = [curppmPath(1:end-4) '.ppm'];
        nextppmPath = fullfile(savePath,'Frames',curnames{im+1});
        nextppmPath = [nextppmPath(1:end-4) '.ppm'];
        
        %make dir 
        if ~exist(curppmPath(1:end-18))
            mkdir(curppmPath(1:end-18))
        end
        if ~exist(nextppmPath(1:end-18))
            mkdir(nextppmPath(1:end-18))
        end
        if ~exist(curPoseFlowPath(1:end-18))
            mkdir(curPoseFlowPath(1:end-18))
        end
        
        %convert frames' format to ppm
%         curframe = imread(curFramePath);
%         curframe = imresize(curframe,opt.dims);
%         imwrite(curframe,curppmPath,'ppm');
%         nextframe = imread(nextFramePath);
%         nextframe = imresize(nextframe,opt.dims);
%         imwrite(nextframe,nextppmPath,'ppm');
%         
        %get joint of current  and next frame 
        curJoints = curgt{im};
        nextJoints = curgt{im+1};
        
%         curJoints = get_insertion_skeleton(curJoints,opt.edges,opt.internums);
%         nextJoints = get_insertion_skeleton(nextJoints,opt.edges,opt.internums);
%         [vx,vy ] = generate_poseflow( curFramePath,curJoints,nextJoints,opt );
%         
%          save(curPoseFlowPath,'vx','vy');
%          mat2flo(curPoseFlowPath);
%          
         
%          flow(:,:,1) = vx;
%          flow(:,:,2) = vy;
%          imflow = flowToColor(flow);
%          img1 = imread(curFramePath);
%          img1 = imresize(img1,opt.dims );
%          imflow = im2double(img1)*0.2+im2double(imflow)*0.7;
%          imshow(imflow);
         
         % write to txt
         fprintf(fid1,curppmPath);
         fprintf(fid1,'	');
         fprintf(fid1,nextppmPath);
         fprintf(fid1,'	');
         fprintf(fid1,curppmPath);
         fprintf(fid1,'	');
         fprintf(fid1,[curPoseFlowPath(1:end-4) '.flo']);
         fprintf(fid1,'\n');
            
         if cmudbDS.set(i)==1
             fprintf(fid2,'1');
         else
             fprintf(fid2,'2');
         end
         fprintf(fid2,'\n');
            
    end
end

