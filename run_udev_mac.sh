#!/usr/bin/env bash

# get wlan address
MAC_ADDRESS="$(cat /sys/class/net/wlan0/address)"

if grep -q $MAC_ADDRESS /etc/udev/rules.d/70-persistent-net.rules; then
    exit 0
else
# put address in net rules
sudo bash -c 'cat > /etc/udev/rules.d/70-persistent-net.rules' << EOF
SUBSYSTEM=="ieee80211", \
ACTION=="add|change", \
ATTR{macaddress}=="$MAC_ADDRESS", \
KERNEL=="phy0", \
RUN+="/sbin/iw phy phy0 interface add ap0 type __ap", \
RUN+="/bin/ip link set ap0 address $MAC_ADDRESS"
EOF
fi
