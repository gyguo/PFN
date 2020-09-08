GLOG_logtostderr=0 GLOG_log_dir=/home/ggy/code/PFN/models/PFNST-CV/Log/ \
Caffe=/home/ggy/code/flownet2-master
Model=/home/ggy/code/PFN/models/PFNST-CV

$Caffe/.build_release/tools/caffe \
 train -solver $Model/solver.prototxt \
 --gpu 1
 2>&1 | tee $Model/Log/train_doc.d