#!/bin/sh

#requires intel driver from xf86-video-intel
#unless you replace intel-xorg.conf 
#with modeset.xorg.conf on the line below.
echo 'Removing nvidia prime setup......'

rm -rf /etc/X11/xorg.conf.d/99-nvidia.conf
rm -rf /etc/modprobe.d/99-nvidia.conf
rm -rf /etc/modules-load.d/99-nvidia.conf
rm -rf /usr/local/bin/optimus.sh

sleep 1

echo 'Removing intel only mode setup......'
rm -rf /etc/X11/xorg.conf.d/99-intel.conf
rm -rf /etc/modprobe.d/99-intel.conf
rm -rf /etc/modules-load.d/99-intel.conf
rm -rf /usr/local/bin/optimus.sh

sleep 1

echo 'Setting intel only mode (wayland).......'
cp /etc/switch/intel/intel-modprobe.conf /etc/modprobe.d/99-intel.conf
cp /etc/switch/intel/no-optimus.sh /usr/local/bin/optimus.sh
sed -i '/WaylandEnable/d' /etc/gdm/custom.conf
sed -i 's/\[daemon\]/\[daemon\]\nWaylandEnable=True/' /etc/gdm/custom.conf

sleep 1

echo 'enabling disable-nvidia.service'
systemctl -q enable disable-nvidia.service
sleep 1
echo 'Done! After reboot you will be using intel only mode (wayland) with the nvidia gpu disabled.'

