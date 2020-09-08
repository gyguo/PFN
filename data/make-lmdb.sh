#!/bin/bash 
caffeDir=/home/ggy/code/flownet2-master
rm -rf /home/ggy/code/PFN/data/pfn_lmdbDS448
$caffeDir/build/tools/convert_image_flow.bin /home/ggy/code/PFN/data/caffe_txt/poseflow_DS448.list /home/ggy/code/PFN/data/pfn_lmdbDS448 0 lmdb