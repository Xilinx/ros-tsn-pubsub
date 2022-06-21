#*****************************************************************************
#
# Copyright (C) 2022 - 2023 Xilinx, Inc.  All rights reserved.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
#******************************************************************************
#
# CMake for example application
#

cmake_minimum_required(VERSION 3.8)
project(xlnx-pubsub)

if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  add_compile_options(-Wall -Wextra -Wpedantic)
endif()

# find dependencies
find_package(ament_cmake REQUIRED)
find_package(rclcpp REQUIRED)
find_package(std_msgs REQUIRED)

add_executable(talker src/pub-control.cpp)
ament_target_dependencies(talker rclcpp std_msgs)

add_executable(listener src/sub-all.cpp)
ament_target_dependencies(listener rclcpp std_msgs)

install(TARGETS
	talker
	listener
	DESTINATION lib/${PROJECT_NAME})

install(FILES ../config/dds_talker_profile.xml DESTINATION etc/${PROJECT_NAME} COMPONENT config)
install(FILES ../config/dds_listener_profile.xml DESTINATION etc/${PROJECT_NAME} COMPONENT config)

install(FILES ../scripts/start_ros_test.sh DESTINATION /opt/xilinx/ros-tsn-example/bin/ )

ament_package()
