#!/usr/bin/env python3

import cv2
import numpy as np
from collections import namedtuple
import time
import pickle
from math import pi
from ins_nav import AHRS
from matplotlib import pyplot as plt
from squaternion import quat2euler, Quaternion


Data_ts = namedtuple('Data_ts', 'data timestamp')
data = pickle.load(open("data.pickle", "rb"))

imgs = [np.frombuffer(x[0], dtype=np.uint8).reshape((480,640)) for x in data['camera']]
itime = [x[1] for x in data['camera']]

for im in imgs:
    # im = cv2.equalizeHist(im)
    cv2.imshow('h', im)
    cv2.waitKey(33)

# plt.plot(imutime, [x[0] for x in save], label='x')
# plt.plot(imutime, [x[1] for x in save], label='y')
# plt.plot(imutime, [x[2] for x in save], label='z')
# plt.legend()
# plt.grid(True)
# plt.show()
