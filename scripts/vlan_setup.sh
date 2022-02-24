#!/bin/bash
#
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
# Configure network for tsn
#

#if [ "$EUID" -ne 0 ]
#	then echo "Please run this script as root!"
#	exit
#fi

EP=${EP:-ep}
ETH1=${ETH1:-eth1}
ETH2=${ETH2:-eth2}

VLAN_ID=${VLAN_ID:-20}

MASTER=${MASTER:-0}

MST_HW_ADDR_EP="00:0a:35:00:01:10"
MST_HW_ADDR_ETH1="00:0a:35:00:01:1e"
MST_HW_ADDR_ETH2="00:0a:35:00:01:1f"

SLV_HW_ADDR_EP="00:0a:35:00:01:20"
SLV_HW_ADDR_ETH1="00:0a:35:00:01:2e"
SLV_HW_ADDR_ETH2="00:0a:35:00:01:2f"

MAC_HIGH=0xF000a

if [ "$MASTER" = "1" ]; then
	HW_ADDR_EP=${MST_HW_ADDR_EP}
	HW_ADDR_ETH1=${MST_HW_ADDR_ETH1}
	HW_ADDR_ETH2=${MST_HW_ADDR_ETH2}
	IP_ADDR=111.222.0.1
	MAC_LOW=0x3500011e
else
	HW_ADDR_EP=$SLV_HW_ADDR_EP
	HW_ADDR_ETH1=$SLV_HW_ADDR_ETH1
	HW_ADDR_ETH2=$SLV_HW_ADDR_ETH2
	MAC_LOW=0x3500012e
	IP_ADDR=111.222.0.2
fi


sudo ip link set $EP   down
sudo ip link set $ETH1 down
sudo ip link set $ETH2 down

sudo ip link set $EP   address $HW_ADDR_EP
sudo ip link set $ETH1 address $HW_ADDR_ETH1
sudo ip link set $ETH2 address $HW_ADDR_ETH2

sudo switch_prog pst -s swp0 --state 4
sudo switch_prog pst -s swp1 --state 4
sudo switch_prog pst -s swp2 --state 4

sudo devmem 0x80078010 32 $MAC_HIGH
sudo devmem 0x8007800c 32 $MAC_LOW

sudo ip addr add ${IP_ADDR}/24 broadcast + dev $EP

sudo ip link set $EP   up
sudo ip link set $ETH1 up
sudo ip link set $ETH2 up
