# ROS2 TSN PubSub Example Application
[![License](https://img.shields.io/badge/license-MIT-green)](./LICENSE)

Ros2 application to demonstate publisher - subscriber over TSN network.

The default FastDDS provides the communication between two nodes over network. This example
override the DDS to have configuration, where the topic messages are filtered through specified
network interface. This interface needs to be configured to do qos mapping of all the traffic to
pcp 4 (which is scheduled traffic in Xilinx TSN by default).

## Install

- Install Ros2 as described in [Ros2 Documentation](https://docs.ros.org/en/humble/Installation/Ubuntu-Install-Debians.html)
- Download the .deb file for kr260 from the [Release Assets](/../../releases) and copy to ~/Downloads.
- Install on target using:
```
# change version number as per your download
sudo apt install ~/Downloads/ros-humble-xlnx-pubsub_0.0.1-0jammy_arm64.deb
```

## Run Instructions

1. Set the network configuration to egress the network traffic only through scheduled traffic.
2. Source ROS envirnoment e.g `source /opt/ros/humble/setup.sh`
3. Run Listener on board 2: `source /opt/xilinx/ros-tsn-example/bin/start_ros_test.sh -l`
4. Run Talker on board 1: `source /opt/xilinx/ros-tsn-example/bin/start_ros_test.sh -t`

## Build Instructions

Install build tools:
```
sudo apt install python3-colcon-common-extensions
```

Source the ros envirnoment:
```
source /opt/ros/humble/setup.sh
```

Clone and build the application:
```
mkdir -p workspace/src
cd workspace
git clone -b xlnx_rel_v2022.1 https://github.com/Xilinx/ros-tsn-pubsub.git src/ros-tsn-pubsub

# Build
colcon build --cmake-args -DSCRIPT_PREFIX="~/install"

# Add the built application to current envirnoment
source install/local_setup.sh

# In future use install/setup.sh to source ros + app
```

## License

```
Copyright (C) 2022 Xilinx, Inc.  All rights reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```
