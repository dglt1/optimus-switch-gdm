#!/bin/sh

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

echo 'Removing intel only mode setup......'
rm -rf /etc/X11/xorg.conf.d/99-intel.conf
rm -rf /etc/modprobe.d/99-intel.conf
rm -rf /etc/modules-load.d/99-intel.conf
rm -rf /usr/local/bin/optimus.sh

sleep 1
echo 'Setting nvidia prime mode.......'

cp /etc/switch/nvidia/nvidia-mhwd.conf /etc/X11/mhwd.d/99-nvidia.conf
cp /etc/switch/nvidia/nvidia-xorg.conf /etc/X11/xorg.conf.d/99-nvidia.conf
cp /etc/switch/nvidia/nvidia-modprobe.conf /etc/modprobe.d/99-nvidia.conf
cp /etc/switch/nvidia/nvidia-modules.conf /etc/modules-load.d/99-nvidia.conf
cp /etc/switch/nvidia/optimus.sh /usr/local/bin/optimus.sh

sleep 1 
echo 'disabling disable-nvidia.service.....'
systemctl -q disable disable-nvidia.service

sleep 1
echo 'Done! After reboot you will be using nvidia prime mode.'
