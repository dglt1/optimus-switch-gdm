#!/bin/sh

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

echo '####################################'
echo '# Custom install script for GDM    #'
echo '# and following GPU BusIDs        #'
echo '# intel iGPU BusID  00:02:0        #'
echo '# nvidia dGPU BusID  01:00:0       #'
echo '####################################'
sleep 2

echo ' '
echo '##################################################################'
echo '# Be sure you have all requirements BEFORE running this script   #'
echo '# linux*-headers acpi_call-dkms xf86-video-intel git xorg-xrandr #'
echo '# ****installing in 5 sec... CTRL+C to abort****                 #'
echo '##################################################################'
sleep 6

echo ' '
echo '##################################################################'
echo '#Errors about removing files can be ignored, I wrote this script #'
echo '#with the most common files in mind, you will not have all of    #'
echo '#them, this is ok!                                               #'
echo '##################################################################'
echo '## IF YOU HAVE ERRORS ABOUT COPYING FILES, SOMETHING IS WRONG   ##'
echo '## CHECK YOUR PERMISSIONS!                                      ##'
echo '##################################################################'
sleep 6

echo ' '
echo 'Removing current nvidia prime setup if applicable......'
rm -rf /etc/X11/mhwd.d/nvidia.conf
rm -rf /etc/X11/mhwd.d/nvidia.conf.nvidia-xconfig-original
echo 'rm -rf /etc/X11/mhwd.d/nvidia.conf*'
rm -rf /etc/X11/xorg.conf.d/90-mhwd.conf
rm -rf /etc/X11/xorg.conf.d/nvidia.conf
rm -rf /etc/X11/xorg.conf.d/optimus.conf
rm -rf /etc/X11/xorg.conf.d/xorg.conf
rm -rf /etc/X11/xorg.conf.d/20-intel.conf
echo 'rm -rf /etc/X11/xorg.conf.d/90-mhwd.conf'
rm -rf /etc/modprobe.d/mhwd-gpu.conf
rm -rf /etc/modprobe.d/optimus.conf
rm -rf /etc/modprobe.d/nvidia.conf
echo 'rm -rf /etc/modprobe.d/mhwd-gpu.conf'
rm -rf /etc/modprobe.d/nvidia-drm.conf
rm -rf /etc/modprobe.d/nvidia.conf
echo 'rm -rf /etc/modprobe.d/nvidia*.conf'
rm -rf /etc/modules-load.d/mhwd-gpu.conf
echo 'rm -rf /etc/modules-load.d/mhwd-gpu.conf'
rm -rf /usr/local/bin/optimus.sh
rm -rf /usr/local/share/optimus.desktop
echo 'rm -rf /usr/local/share/optimus.desktop'
sleep 2

echo 'Copying contents of ~/optimus-switch-gdm/* to /etc/ .......'
cp -r ./switch /etc/
sleep 2

echo 'Copying optimus-switch-uninstall.sh to /usr/local/bin/' 
cp ./optimus-switch-uninstall.sh /usr/local/bin/optimus-switch-uninstall.sh
sleep 2

echo 'Copying set-intel-x11.sh, set-intel-wayland.sh and set-nvidia.sh to /usr/local/bin/'
cp /etc/switch/set-intel-x11.sh /usr/local/bin/set-intel-x11.sh
cp /etc/switch/set-intel-wayland.sh /usr/local/bin/set-intel-wayland.sh
cp /etc/switch/set-nvidia.sh /usr/local/bin/set-nvidia.sh
cp /etc/switch/optimus.desktop /usr/local/share/optimus.desktop
sleep 1

echo 'Copying disable-nvidia.service to /etc/systemd/system/'
cp /etc/switch/intel/disable-nvidia.service /etc/systemd/system/disable-nvidia.service
chown root:root /etc/systemd/system/disable-nvidia.service
chmod 644 /etc/systemd/system/disable-nvidia.service
sleep 1

echo 'Creating symlinks ("file exists" errors can be ignored)....... '
ln -s /usr/local/share/optimus.desktop /usr/share/gdm/greeter/autostart/optimus.desktop
ln -s /usr/local/share/optimus.desktop /etc/xdg/autostart/optimus.desktop
sleep 1

echo 'Setting nvidia prime mode (sudo set-nvidia.sh).......'
cp /etc/switch/nvidia/nvidia-xorg.conf /etc/X11/xorg.conf.d/99-nvidia.conf
cp /etc/switch/nvidia/nvidia-modprobe.conf /etc/modprobe.d/99-nvidia.conf
cp /etc/switch/nvidia/nvidia-modules.conf /etc/modules-load.d/99-nvidia.conf
cp /etc/switch/nvidia/optimus.sh /usr/local/bin/optimus.sh
sed -i '/WaylandEnable/d' /etc/gdm/custom.conf
sed -i 's/\[daemon\]/\[daemon\]\nWaylandEnable=False/' /etc/gdm/custom.conf
sleep 1

echo 'Setting permissions........'
chmod +x /usr/local/bin/set-intel-x11.sh
chmod +x /usr/local/bin/set-intel-wayland.sh
chmod +x /usr/local/bin/set-nvidia.sh
chmod a+rx /usr/local/bin/optimus.sh
chmod +x /usr/local/bin/optimus-switch-uninstall.sh
chmod a+rx /etc/switch/intel/no-optimus.sh
chmod a+rx /etc/switch/nvidia/optimus.sh
chmod +x /etc/switch/gpu_switch_check.sh
sleep 1

echo 'Current boot mode is set to nvidia prime.'
echo 'you can switch to intel only mode with sudo set-intel-x11.sh or set-intel-wayland.sh and reboot.'
sleep 1

echo 'Install finished!'

