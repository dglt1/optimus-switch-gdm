#!/bin/sh

#optimus-switch (GDM) uninstall script.

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

echo 'Removing optimus-switch'

rm -rf /usr/local/bin/set-intel-x11.sh
rm -rf /usr/local/bin/set-intel-wayland.sh
rm -rf /usr/local/bin/set-nvidia.sh
rm -rf /usr/local/bin/optimus.sh
rm -rf /etc/switch

systemctl disable disable-nvidia.service
rm -rf /etc/systemd/system/disable-nvidia.service

rm -rf /etc/X11/mhwd.d/99-nvidia.conf
rm -rf /etc/X11/xorg.conf.d/99-nvidia.conf
rm -rf /etc/modprobe.d/99-nvidia.conf
rm -rf /etc/modules-load.d/99-nvidia.conf

rm -rf /etc/X11/xorg.conf.d/99-intel.conf
rm -rf /etc/modprobe.d/99-intel.conf
rm -rf /etc/modules-load.d/99-intel.conf
rm -rf /usr/local/share/optimus.desktop

sed -i '/WaylandEnable/d' /etc/gdm/custom.conf
sed -i 's/\[daemon\]/\[daemon\]\nWaylandEnable=False/' /etc/gdm/custom.conf

echo '#############################################################'
echo '#optimus-switch is now uninstalled & wayland is disabled    #'
echo '#if you reboot now, you will not have a working Xorg setup. #'    
echo '#setup another optimus solution before rebooting            #'
echo '#############################################################'
rm -rf optimus-switch-uninstall.sh
