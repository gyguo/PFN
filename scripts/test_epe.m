%
clear;
clc;

%setup caffe
addpath('/home/ggy/code/PFN/flownet2-master/matlab');
caffe.set_mode_gpu();
gpu_id =3;  % we will use the first gpu in this demo
caffe.set_device(gpu_id);

opt.poseFlowSet = 'PFNST-CV';
opt.dims = [448,448];%size of frames

%set path
rootPath = '/home/ggy/code/PFN';
poseFlowPath = fullfile(rootPath,'models', opt.poseFlowSet );
gtPath = fullfile(rootPath,'data','PoseFlow-DS-448' ,'gt');
resPath = fullfile(rootPath,'data','results',[opt.poseFlowSet '-0.0001-epe']);
cmudbDSPath =  fullfile(rootPath,'data','cmudbDS.mat');

addpath(genpath(fullfile(rootPath,'tools','Optical_Flow')))
addpath(fullfile(rootPath,'tools','FlowFile'))
addpath(fullfile(rootPath,'tools','test'))

%load index
cmudbDS = load(cmudbDSPath);
cmudbDS = cmudbDS.cmudbDS;
framesPath =cmudbDS.framesPath;

%% adj net
net_weights = [ fullfile(poseFlowPath,'snapshots','pfn_iter_66840.caffemodel')];
net_model = [fullfile(poseFlowPath,'deploy.prototxt')];
if ~exist(net_weights, 'file')
    error('Please download net_weights  before you run this demo');
end
if ~exist(net_model, 'file')
    error('Please download net_model  before you run this demo');
end
net = caffe.Net(net_model, net_weights, 'test');


%% test
res.trainAEE = {};
res.testAEE = {};
num = 0;
%evalulate results
for i =1:numel(cmudbDS.set)
    
    fprintf('test:save results:%d/%d\n',i,numel(cmudbDS.set));
    
    curgt = cmudbDS.gt{i}.joints;
    curnames = cmudbDS.gt{i}.names;
    for im = 1:cmudbDS.nFrames(i)-1
        
        num = num+1;
        
        %set path for generated data
        curResPath = fullfile(resPath,'res',curnames{im} );
        curResPath = [curResPath(1:end-4) '.jpg'];
        curGtImPath = fullfile(resPath,'gt',curnames{im} );
        curGtImPath = [curGtImPath(1:end-4) '.jpg'];
        
        curFramePath = fullfile(framesPath ,curnames{im} );
        nextFramePath = fullfile(framesPath ,curnames{im+1});
        
        if ~exist(curResPath(1:end-18))
            mkdir(curResPath(1:end-18))
        end
        %         if ~exist(curGtImPath(1:end-18))
        %             mkdir(curGtImPath(1:end-18))
        %         end
        
        %test
        img1 = caffe.io.load_image(curFramePath);
        img2 = caffe.io.load_image(nextFramePath);
        img1 = imresize(img1,opt.dims);
        img2 = imresize(img2,opt.dims);
        image{1}=img1;
        image{2}=img2;
        
        score=net.forward(image);
        
        data = net.blobs('predict_flow_final').get_data();
        map = data(:,:,1);
        map = double(map);
        vx = permute(map, [2, 1]);
        %vx = map;
        
        map=data(:,:,2);
        map=double(map);
        vy = permute(map, [2, 1]);
        %vy = map;
        
        curFlow(:,:,1) = vx;
        curFlow(:,:,2) = vy;
        
        
%         imflow = flowToColor(curFlow);
%         curGtPath =  fullfile(gtPath,curnames{im} );
%         curGtPath = [curGtPath(1:end-4) '.flo'];
%         curGt = readFlowFile(curGtPath);
%         gtflow = flowToColor(curGt );
%         figure(1)
%         subplot(1,2,1)
%         imshow(imflow)
%         subplot(1,2,2)
%         imshow(gtflow)
%         pause
        
        
        
        %evalulate
        curGtPath =  fullfile(gtPath,curnames{im} );
        curGtPath = [curGtPath(1:end-4) '.flo'];
        curGt = readFlowFile(curGtPath);
        aee = get_epe(curGt,curFlow);
        
        %save flow as .jpg
        %gtflow = flowToColor(curGt );
        resflow = flowToColor(curFlow);
        %imwrite(gtflow, curGtImPath);
        imwrite(resflow,curResPath);
        
        if cmudbDS.set(i) ==1
            res.trainAEE = [ res.trainAEE;aee];
        else
            res.testAEE = [ res.testAEE;aee];
        end
        
    end
    
    fprintf('epe on test:%f, epe on train:%f\n',mean(cell2mat(res.testAEE)),mean(cell2mat(res.trainAEE)));
end
caffe.reset_all();
meanTrainAEE = mean(cell2mat(res.trainAEE));
meanTestAEE = mean(cell2mat(res.testAEE));

resFile = fullfile(resPath,'res.mat');
save(resFile,'res','meanTrainAEE','meanTestAEE');
