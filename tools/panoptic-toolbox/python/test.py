import numpy as np
import json
import matplotlib.pyplot as plt
#%matplotlib inline
plt.rcParams['image.interpolation'] = 'nearest'

# For camera projection (with distortion)
import panutils

# Setup paths
data_path = '../'
seq_name = 'sampleData'

vga_skel_json_path = data_path+seq_name+'/vgaPose3d_stage1/'
vga_img_path = data_path+seq_name+'/vgaImgs/'

hd_skel_json_path = data_path+seq_name+'/hdPose3d_stage1/'
hd_img_path = data_path+seq_name+'/hdImgs/'

with open(data_path+seq_name+'/calibration_{0}.json'.format(seq_name)) as cfile:
    calib = json.load(cfile)

# Cameras are identified by a tuple of (panel#,node#)
cameras = {(cam['panel'],cam['node']):cam for cam in calib['cameras']}
# Convert data into numpy arrays for convenience
for k,cam in cameras.iteritems():
    cam['K'] = np.matrix(cam['K'])
    cam['distCoef'] = np.array(cam['distCoef'])
    cam['R'] = np.matrix(cam['R'])
    cam['t'] = np.array(cam['t']).reshape((3,1))

# Select the first 10 VGA cameras in a uniformly sampled order
cams = panutils.get_uniform_camera_order()[0:10]
sel_cameras = [cameras[cam].copy() for cam in cams]

# Edges between joints in the skeleton
edges = np.array([[1,2],[1,4],[4,5],[5,6],[1,3],[3,7],[7,8],[8,9],[3,13],[13,14],[14,15],[1,10],[10,11],[11,12]])-1
colors = plt.cm.hsv(np.linspace(0, 1, 10)).tolist()

# # Frame
# idx = 0
#
# plt.figure(figsize=(15,15))
# for icam in xrange(6):
#     # Select a camera
#     cam = sel_cameras[icam]
#
#     # Load the corresponding frame
#     image_path = vga_img_path+'{0:02d}_{1:02d}/{0:02d}_{1:02d}_{2:08d}.jpg'.format(cam['panel'], cam['node'], idx)
#
#     im = plt.imread(image_path)
#
#     plt.subplot(3,2,icam+1)
#     plt.imshow(im)
#     currentAxis = plt.gca()
#     currentAxis.set_autoscale_on(False)
#
#     try:
#         # Load the json file with this frame's skeletons
#         skel_json_fname = vga_skel_json_path+'body3DScene_{0:08d}.json'.format(idx)
#         with open(skel_json_fname) as dfile:
#             bframe = json.load(dfile)
#
#         # Cycle through all detected bodies
#         for body in bframe['bodies']:
#
#             # There are 15 3D joints, stored as an array [x1,y1,z1,c1,x2,y2,z2,c2,...]
#             # where c1 ... c15 are per-joint detection confidences
#             skel = np.array(body['joints15']).reshape((-1,4)).transpose()
#
#             # Project skeleton into view (this is like cv2.projectPoints)
#             pt = panutils.projectPoints(skel[0:3,:],
#                           cam['K'], cam['R'], cam['t'],
#                           cam['distCoef'])
#
#             # Show only points detected with confidence
#             valid = skel[3,:]>0.1
#             # print np.shape(pt)
#             # print pt
#             plt.plot(pt[0,valid], pt[1,valid], '.', color=colors[body['id']])
#
#             # Plot edges for each bone
#             for edge in edges:
#                 if valid[edge[0]] or valid[edge[1]]:
#                     plt.plot(pt[0,edge], pt[1,edge], color=colors[body['id']])
#
#             # Show the joint numbers
#             for ip in xrange(pt.shape[1]):
#                 if pt[0,ip]>=0 and pt[0,ip]<im.shape[1] and pt[1,ip]>=0 and pt[1,ip]<im.shape[0]:
#                     plt.text(pt[0,ip], pt[1,ip]-5, '{0}'.format(ip),color=colors[body['id']])
#
#             # plt.show()
#
#     except IOError as e:
#         print('Error reading {0}\n'.format(skel_json_fname)+e.strerror)
#
#     # Also plot selected cameras with (panel,node) label
#     for ca in sel_cameras:
#         cc = (-ca['R'].transpose()*ca['t'])
#         pt = panutils.projectPoints(cc,
#                       cam['K'], cam['R'], cam['t'],
#                       cam['distCoef'])
#         if pt[0]>=0 and pt[0]<im.shape[1] and pt[1]>=0 and pt[1]<im.shape[0]:
#             plt.plot(pt[0], pt[1], '.', color=[0,1,0], markersize=5)
#             plt.text(pt[0], pt[1], 'cam({0},{1})'.format(ca['panel'],ca['node']), color=[1,1,1])
#
# plt.tight_layout()

# HD frame
idx = 0

plt.figure(figsize=(15,15))
# Select an HD camera
cam = cameras[(0,0)]

# Load the corresponding frame
image_path = hd_img_path+'{0:02d}_{1:02d}/{0:02d}_{1:02d}_{2:08d}.jpg'.format(cam['panel'], cam['node'], idx)
im = plt.imread(image_path)
print image_path
plt.imshow(im)
currentAxis = plt.gca()
currentAxis.set_autoscale_on(False)

try:
   # Load the json file with this frame's skeletons
   skel_json_fname = hd_skel_json_path+'body3DScene_{0:08d}.json'.format(idx)
   with open(skel_json_fname) as dfile:
       bframe = json.load(dfile)

   print bframe['bodies']

   # Cycle through all detected bodies
   for body in bframe['bodies']:

       # There are 15 3D joints, stored as an array [x1,y1,z1,c1,x2,y2,z2,c2,...]
       # where c1 ... c15 are per-joint detection confidences
       skel = np.array(body['joints15']).reshape((-1,4)).transpose()

       # Project skeleton into view (this is like cv2.projectPoints)
       pt = panutils.projectPoints(skel[0:3,:],
                                   cam['K'], cam['R'], cam['t'],
                                   cam['distCoef'])

       # Show only points detected with confidence
       valid = skel[3,:]>0.1

       plt.plot(pt[0,valid], pt[1,valid], '.', color=colors[body['id']])

       # Plot edges for each bone
       for edge in edges:
           if valid[edge[0]] or valid[edge[1]]:
               plt.plot(pt[0,edge], pt[1,edge], color=colors[body['id']])

       # Show the joint numbers
       for ip in xrange(pt.shape[1]):
           if pt[0,ip]>=0 and pt[0,ip]<im.shape[1] and pt[1,ip]>=0 and pt[1,ip]<im.shape[0]:
               plt.text(pt[0,ip], pt[1,ip]-5, '{0}'.format(ip),color=colors[body['id']])

       plt.show()

except IOError as e:
   print('Error reading {0}\n'.format(skel_json_fname)+e.strerror)
