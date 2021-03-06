# PFN
This is the release for paper "PoseFlow: A Deep Motion Representation for Understanding Human Behaviors in Videos" CVPR2018

## Running

1. ##### Download  [CMU Panoptic dataset](http://domedb.perception.cs.cmu.edu/), we use "Pose" subset

2. ##### Select images and generate ground truth poseflow 
- generate mat file for the dataset

```
run scripts/get_continuous_data.m 
```

you can skip this step by downloading the results form [Google Drive](https://drive.google.com/file/d/1_5XtfKWhMz4RlhJq-jJWjpA9B6Z2C312/view?usp=sharing)

- sampling the data with random duration

```
run scripts/generate_DS_database.m  # down sampling the data
```

- generate poseflow ground truth

```
run scripts/generate_DS_poseFlow448_data.m # generate ground truth
```

3. ##### Prepare caffe, we use [Caffe for FlowNet2 ](https://github.com/lmb-freiburg/flownet2)

4. ##### Generate hmdb file before training 

```
sh data/make-lmdb.sh
```

5. ##### Training PFN

```
sh models/PFNST-CV/train.sh
```

6. ##### Test and generate poseflow

```
run scripts/test_epe.m
```

## Model download

The trained model can be downloaded from  [Google Drive](https://drive.google.com/file/d/1fREbtXEl5QILds6WCDu8jOS2q0DPq5gg/view?usp=sharing)

## gitee
code has also been released in [gitee](https://gitee.com/gyguo95/PFN)
## Citation

When using the code in your research work, please cite the following paper:

```
@inproceedings{zhang2018poseflow,
  title={PoseFlow: A Deep Motion Representation for Understanding Human Behaviors in Videos},
  author={Zhang, Dingwen and Guo, Guangyu and Huang, Dong and Han, Junwei},
  booktitle={2018 IEEE/CVF Conference on Computer Vision and Pattern Recognition},
  pages={6762--6770},
  year={2018},
  organization={IEEE}
}
```

