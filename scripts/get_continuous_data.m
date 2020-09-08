clc;
clear;

%set path
rootPath = '/home/ggy/code/PFN';
datasetPath = '/home/ggy/code/PFN/data/dataset/CMU_Panoptic_Dataset';
addpath(genpath(fullfile(rootPath,'tools','panoptic-toolbox')));
savePath = fullfile(rootPath,'data','database');

if ~exist(savePath)
    mkdir(savePath);
end
selectedData = load(fullfile(rootPath, 'data','selecteddata.mat'));

%set up dataset
cmudb.framesPath = datasetPath;
cmudb.nFrames = {};
cmudb.names = {};
cmudb.gt = [];
for i = 1:numel(selectedData.breakPoints)+1
    
    fprintf('%d/%d\n',i,numel(selectedData.breakPoints)+1);
    
    %get number of frames between two breakpoints
    if i == 1
        numContData = selectedData.breakPoints(i);
        startPoint = 1;
        endPiont = selectedData.breakPoints(i);
    elseif i == numel(selectedData.breakPoints)+1
        numContData = numel(selectedData.breakPoints)-selectedData.breakPoints(i-1);
        startPoint = selectedData.breakPoints(i-1)+1;
        endPiont = numel(selectedData.breakPoints);
    else
        numContData = selectedData.breakPoints(i)-selectedData.breakPoints(i-1);
        startPoint = selectedData.breakPoints(i-1)+1;
        endPiont = selectedData.breakPoints(i);
    end
    
    %select continous data which lager than 3
    if numContData>=3
     
        curnames =  selectedData.selectedData(startPoint:endPiont);
        curgt.joints = selectedData.selectedLabel(startPoint:endPiont);
        curNFrames = endPiont - startPoint + 1;
        
        cmudb.nFrames = horzcat(cmudb.nFrames,curNFrames);
        cmudb.names =horzcat(cmudb.names,cell2mat(curnames));
        cmudb.gt = horzcat(cmudb.gt,curgt);
    end
    
end
cmudb.set = randi(2,numel(cmudb.gt),1);
save(fullfile(savePath,'cmudb.mat'),'-struct','cmudb','-v7.3');