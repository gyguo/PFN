% down sampleing 
clc;
clear;

%set path
rootPath = rootPath = '/home/ggy/code/PFN';
cmudbPath =  fullfile(rootPath,'data','cmudb.mat');
addpath(genpath(fullfile(rootPath,'tools','panoptic-toolbox')));
savePath = fullfile(rootPath,'data','cmudbDS.mat');

%set sampleRate and continous number
sr = 5;
nseq = 15;

%load dataset
cmudb = load(cmudbPath);

cmudbDS.framesPath = cmudb.framesPath;
cmudbDS.gt = {};
cmudbDS.nFrames = [];
cmudbDS.set = [];
for i =1:numel(cmudb.set)
    
   fprintf('%d/%d\n',i,numel(cmudb.set));
   
    curgt = cmudb.gt{i}.joints;
    curnames = cmudb.names{i};
    curNFrames = cmudb.nFrames{i};
    
    %downsampling
    curds.gt.joints = {};
    curds.gt.names = {};
    dsNFrames = 0;
    dsset = cmudb.set(i);
    if curNFrames>=sr*nseq
        for im = 1:curNFrames
            if rem(im-1,sr)==0
                
              curds.gt.joints  = vertcat(curds.gt.joints ,curgt{im});
              curds.gt.names = vertcat(curds.gt.names,curnames(im,:));
              dsNFrames = dsNFrames +1;
            end
        end
        
        cmudbDS.gt = horzcat(cmudbDS.gt,curds.gt);
        cmudbDS.nFrames = horzcat(cmudbDS.nFrames,dsNFrames);
        cmudbDS.set =horzcat(cmudbDS.set,dsset);  
    end

    
end
save(savePath,'cmudbDS');

