#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import cv2
from imutils.video import VideoStream
from nxp_imu import IMU
from pydar import URG04LX
import platform
from collections import namedtuple
import time
import pickle

Data_ts = namedtuple('Data_ts', 'data timestamp')


data = {
    'imu': [],
    'camera': [],
    'lidar': []
}



if __name__ == "__main__":
    print("<<< START >>>")

    imu = IMU(gs=2, dps=250)

    if platform.system().lower() == 'linux':
        args = {
            'src': 0,
            'usePiCamera': True,
            'resolution': (640,480,),
            'framerate': 10
        }

        port = '/dev/serial/by-id/usb-Hokuyo_Data_Flex_for_USB_URG-Series_USB_Driver-if00'
    else:
        args = {
            'src': 0,
            'usePiCamera': False
        }

        port = ''

    cam = VideoStream(**args).start()

    lidar = URG04LX()
    # if not lidar.open(port):
    #     exit(1)

    start = time.time()

    try:
        # while(True):
        for cnt in range(1000):
            loop_start = time.time()

            if cnt%20 == 0:
                print("\n{}\n".format(cnt))
            else:
                print(".", end='')

            d = imu.get()
            data['imu'].append(Data_ts(d, time.time()-start))

            # d = lidar.capture()
            # print(d)
            # data['lidar'].append(Data_ts(d, time.time()-start))

            img = cam.read()
            while img is None:
                print("cv2 crap")
                time.sleep(1)
                img = cam.read()
            img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
            d = img.tobytes()
            data['camera'].append(Data_ts(d, time.time()-start))

            diff = time.time() - loop_start
            if diff < 0.1:
                time.sleep(0.1 - diff)



    except KeyboardInterrupt:
        pass

    finally:
        cam.stop()
        lidar.close()
        pickle.dump( data, open( "data.pickle", "wb" ) )
