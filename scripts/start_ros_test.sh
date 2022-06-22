#!/bin/bash
#
#*****************************************************************************
#
# Copyright (C) 2022 Xilinx, Inc.  All rights reserved.
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
# Run Ros2 example application
#

function print_help() {
	echo -e "Usage:"
	echo -e "  $0 <exactly one Option>"
	echo -e "Options:"
	echo -e "  -h, --help       Display this help"
	echo -e "  -t, --talker     Start Ros xln-pubsub talker"
	echo -e "  -l, --listener   Start Ros xln-pubsub listener"
}

ROS_PREFIX=${AMENT_PREFIX_PATH}
PKG_NAME="xlnx-pubsub"

if [ "$#" -ne 1 ];
then
	echo "Pass exactly 1 argument"
	print_help
	return
fi

if [ -z ${ROS_VERSION+x} ];
then
	echo "ROS envirnoment not set. Please source <ros installation>/bin/setup.sh"
	echo "typically: "
	echo "		source /opt/ros/humble/setup.bash"
	return
fi

echo "ROS_DISTRO=$ROS_DISTRO"
echo "ROS_VERSION=$ROS_VERSION"

case $1 in
	-h | --help )
		print_help
		return 0
		;;
	-t | --talker )
		application=talker
		;;
	-l | --listener )
		application=listener
		;;
	* )
		echo "Invalid argument $1"
		print_help
		return 1;
		;;
esac

profile=${ROS_PREFIX}/etc/${PKG_NAME}/dds_${application}_profile.xml

white_list=$(awk -F '[<>]' '/address/{print $3}' $profile)

if ! $(ip addr show | grep -q ${white_list}); then
	echo "Whitelist IP $white_list not configured"
	echo "Please run net_setup.sh first"
	return 1
fi

export FASTRTPS_DEFAULT_PROFILES_FILE=$profile

echo "Ros2 $application is now running. do CTRL-C to exit"
sleep 1

ros2 run ${PKG_NAME} $application

