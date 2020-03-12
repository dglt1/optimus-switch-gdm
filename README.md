# optimus-switch for GNOME Display Manager (GDM)
## Introduction
optimus-switch is a set of bash scripts, that allows to easily switch between an integrated graphics processors (iGP) by Intel and a graphics processor unit (GPU) by Nvidia on supported platforms.
## Features
- optimus-switch for GDM provides 3 modes of operation
  - intel (wayland) using the iGP and utilizing the wayland protocol
  - intel (X11) using the iGP and utilizing the X11 protocol
  - nvidia (X11) using the GPU and utilizing the X11 protocol
- By utilizing the **acpi_call ** kernel module optimus-switch for GDM is able to fully power down the Nvidia GPU when not in use without negatively affecting sleep & suspend cycles

## Requirements & Dependencies
### General
- Archlinux-based distribution
- Gnome >= 3.10
- kernel headers
- acpi_call
- git
- xorg-xrandr
- NVIDIA driver for linux
- X.org Intel i810/i830/i915/945G/G965+ video drivers

### Requirements & Dependencies for Manjaro
1. `sudo pacman -S linuxXXX-headers acpi_call-dkms xorg-xrandr xf86-video-intel git`  (replace XXX with your kernel version)

2. `sudo modprobe acpi_call` (insert acpi_call into the live kernel so no reboot is required)

3. `mhwd --pci -li`  (prints installed video drivers)

4. `sudo mhwd -r pci name-of-video-driver` (remove all drivers except for **video-linux**  )

5. `mhwd --pci -la` (prints available video drivers)

6. `sudo mhwd -i video-hybrid-intel-nvidia-xxxxx-prime` (install optimus compatible nvidia driver - choose version according to hardware support)

## Installation
### Cleaning up
If you have any custom video/gpu .conf files in the following directories, backup/delete them (they can not remain there). The install script removes the most common ones, but custom file names won't be noticed (only you know if they exist).
```
/etc/X11/
/etc/X11/mhwd.d/
/etc/X11/xorg.conf.d/
/etc/modprobe.d/
/etc/modules-load.d/
```
### Adapting PCI Bus ID
optimus-switch for GDM assumes a PCI Bus ID equal to `01:00:0` for a Nvidia GPU.
Please check the PCI Bus ID of your Nvidia GPU **before** installing and change it here `~/optimus-switch-gdm/switch/nvidia/nvidia-xorg.conf` 
### Installation
```
git clone https://github.com/dglt1/optimus-switch-gdm.git
cd ~/optimus-switch-gdm
chmod +x install.sh
sudo ./install.sh
sudo reboot
```
If the install script throws  “*file does not exist*” errors its because it’s trying to remove the usual - mhwd-gpu/nvidia files that you may/may not have removed. Only errors **after** "copying" starts should be of any concern!

After the installation optimus-switch for GDM is set to nvidia(X11).

## Usage
### General
`sudo set-intel-wayland.sh` switches to intel(wayland) after a reboot
`sudo set-intel-x11.sh` switches to intel(X11) after a reboot
`sudo set-nvidia.sh` switches to nvidia(X11) after a reboot

### Power Managment
You may notice that the nvidia gpu is not yet fully disabled after you boot into one of the intel modes. Unfortuantely you cant run acpi_call to power off the Nvidia GPU while using it (it hard locks the system).

To fix this run the following script in terminal once you are booted into an intel only session:
  `sudo /etc/switch/gpu_switch_check.sh`

You should see a list of various acpi calls, find the one that says “works!” , copy it and then:
  `sudo nano /etc/switch/intel/no-optimus.sh`

At the bottom you will see 2 lines commented out
```
#echo '\_SB.PCI0.PEG0.PEGP._OFF' > /proc/acpi/call 
#echo -n 1 > '/sys/bus/pci/devices/0000:01:00.0/remove'
```

uncomment them and replace the acpi call with the one you just copied. If your nvidia BusID is not `1:00:0` edit BusID's on both lines that - specify BusID's, save/exit. Then:
```
sudo set-intel.sh
reboot
```

The nvidia gpu should be disabled and no longer visible (inxi, mhwd, lspci wont see it). Let me know how it goes, or if you notice anything that could be improved upon. 


## Misc
### manjaroptimus-appindicator
Indicator and GUI switch for optimus-switch on Manjaro
https://github.com/linesma/manjaroptimus-appindicator-gdm

