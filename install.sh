#!/bin/sh

####################################
# custom install script for GDM    #
# and following GPU BusID's        #
# intel iGPU BusID  00:02:0        #
# nvidia dGPU BusID  01:00:0       #
####################################

echo 'Removing current nvidia prime setup......'
rm -rf /etc/X11/mhwd.d/nvidia.conf
echo 'rm -rf /etc/X11/mhwd.d/nvidia.conf'
rm -rf /etc/X11/xorg.conf.d/90-mhwd.conf
echo 'rm -rf /etc/X11/xorg.conf.d/90-mhwd.conf'
rm -rf /etc/modprobe.d/mhwd-gpu.conf
echo 'rm -rf /etc/modprobe.d/mhwd-gpu.conf'
#rm -rf /etc/modprobe.d/nvidia-drm.conf
#echo 'rm -rf /etc/modprobe.d/nvidia-drm.conf'
rm -rf /etc/modules-load.d/mhwd-gpu.conf
echo 'rm -rf /etc/modules-load.d/mhwd-gpu.conf'
##rm -rf /usr/local/bin/optimus.sh  ???
rm -rf /usr/local/share/optimus.desktop
echo 'rm -rf /usr/local/share/optimus.desktop'
sleep 2
echo 'Copying /switch & contents to /etc/switch/ .......'
cp -r /home/dglt/optimus-switch-gdm/switch/ /etc/

sleep 2
echo 'Copying set-intel.sh and set-nvidia.sh to /usr/local/bin/'

cp /etc/switch/set-intel.sh /usr/local/bin/set-intel.sh

cp /etc/switch/set-nvidia.sh /usr/local/bin/set-nvidia.sh

cp /etc/switch/optimus.desktop /usr/local/share/optimus.desktop

sleep 1
echo 'Copying disable-nvidia.service to /etc/systemd/system/'
cp /etc/switch/intel/disable-nvidia.service /etc/systemd/system/disable-nvidia.service
chown root:root /etc/systemd/system/disable-nvidia.service
chmod 644 /etc/systemd/system/disable-nvidia.service

sleep 1
echo 'Creating symlinks...'
ln -s /usr/local/share/optimus.desktop /usr/share/gdm/greeter/autostart/optimus.desktop
ln -s /usr/local/share/optimus.desktop /etc/xdg/autostart/optimus.desktop

sleep 1
echo 'Setting nvidia prime mode.......'

cp /etc/switch/nvidia/nvidia-mhwd.conf /etc/X11/mhwd.d/99-nvidia.conf
cp /etc/switch/nvidia/nvidia-xorg.conf /etc/X11/xorg.conf.d/99-nvidia.conf
cp /etc/switch/nvidia/nvidia-modprobe.conf /etc/modprobe.d/99-nvidia.conf
cp /etc/switch/nvidia/nvidia-modules.conf /etc/modules-load.d/99-nvidia.conf
cp /etc/switch/nvidia/optimus.sh /usr/local/bin/optimus.sh

sleep 1
echo 'Setting permissions........'
chmod +x /usr/local/bin/set-intel.sh
chmod +x /usr/local/bin/set-nvidia.sh
chmod a+rx /usr/local/bin/optimus.sh
chmod a+rx /etc/switch/intel/no-optimus.sh
chmod a+rx /etc/switch/nvidia/optimus.sh

sleep 1
echo 'Currently boot mode is set to nvidia prime.'
echo 'you can switch to intel only mode with sudo set-intel.sh and reboot.'
sleep 1
echo 'Install finished!'



