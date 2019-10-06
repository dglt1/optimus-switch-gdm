# optimus-switch-gdm
- if your looking for the SDDM or LightDM versions, you can get to those repo's here https://github.com/dglt1
- this is a modified and more complete version of my lightDM scripts, made to work with gdm/gnome. 
- includes an install script to remove conflicting configurations, blacklist, drivers/modules. 
- made by a manjaro user for use with manjaro linux. (other distros would require modification)
- 
- this install script and accompanying scripts/.conf files will setup an intel/nvidia PRIME setup that will provide
- the best possible performance for your intel/nvidia optimus laptop. optimus-switch will also allow for easy switching between
- intel/nvidia (prime) mode and an intel only mode that also completely powers down and removes the nvidia gpu
- from sight allowing for improved battery life, and not negatively effect sleep/suspend cycles.

  - this script by default is for an intel gpu with a ~~BusID 0:2:0~~
  - EDIT: intel BusID is only needed if intel drivers require it to work (i have not found this to be the case).
  - and an nvidia gpu with BusID 01:00:0`
  - you can verify this in terminal with this command `lspci | grep -E 'VGA|3D'`
  - if yours does not match, edit ~~/optimus-switch-gdm/switch/intel/intel-xorg.conf to match your BusID~~
  - and ~/optimus-switch-gdm/switch/nvidia/nvidia-xorg.conf  to match your nvidia BusID
  - DO THIS BEFORE RUNNING INSTALL SCRIPT, that is, if you want it to work anyway.
  - note: output like this "00:02.0 VGA " has to be formatted like this `0:2:0` in nvidia-xorg.conf for it to work properly.


Lets begin.
- requirements:
 - check `mhwd -li` to see what video drivers are installed, for this to work, you need only
 - video-nvidia installed, if you have others, start by removing them like this.
 - `sudo mhwd -r pci name-of-video-driver` (remove any/all drivers besides video-nvidia.)
- if you dont already have video-nvidia installed, do that now:
- `sudo mhwd -i pci video-nvidia`

Note: there has been a recent change to how nvidia drivers are handled and are now split into these options for better selection. so choose one that works with your hardware.
```
video-nvidia-340xx
video-nvidia-390xx
video-nvidia-418xx
video-nvidia-430xx
video-nvidia-435xx
```

 - `sudo pacman -S linuxXXX-headers acpi_call-dkms xorg-xrandr xf86-video-intel git` (replace linuxXXX-headers with the kernel version your using, for example linux419-headers is for the 4.19 kernel, so edit to match) 
 - `sudo modprobe acpi_call`

- if you have any custom video/gpu .conf files in the following directories, backup/delete them. (they can not remain there).
- the install script removes the most common ones, but custom file names wont be noticed. only you know if they exist.
- and clearing the entire directory would likely break other things, this install will not do that. so clean up if necessary.
   - /etc/X11/
   - /etc/X11/mhwd.d/
   - /etc/X11/xorg.conf.d/
   - /etc/modprobe.d/
   - /etc/modules-load.d/
   -
- in terminal, from your home directory ~/  (this is important for the install script to work properly)
- 
- `git clone https://github.com/dglt1/optimus-switch-gdm.git`
- `cd ~/optimus-switch-gdm`
- `chmod +x install.sh`
- `sudo ./install.sh`
- 
-  after reboot you will be using intel/nvidia prime. 
- 
- to change the default mode to intel only, run:`sudo set-intel.sh`
- to switch the default mode to intel/nvidia prime, run: `sudo set-nvidia.sh`
- 
-  

- you may notice that after you boot into the intel only mode that the nvidia gpu is not yet disabled and its because you - cant run a proper acpi_call test while using the nvidia gpu. (it hard locks the system).

- so once your booted into an intel only session run this in terminal:
- `sudo /etc/switch/gpu_switch_check.sh`

you should see a list of various acpi calls, find the one that says “works!” , copy it. and then:
`sudo nano /etc/switch/intel/no-optimus.sh`

at the bottom you will see 2 lines #commented out, uncomment them (remove #) and if the acpi call is different from the one you just copied, edit/replace with the good one. also be sure nvidia's BusID matches. save/exit.

then:

sudo set-intel.sh
reboot

the nvidia gpu should be disabled and no longer visible. let me know how it goes, or if you notice anything that could be improved upon.

note: if you see errors about “file does not exist” when you run install.sh its because it’s trying to remove the usual mhwd-gpu/nvidia files that you may/may not have removed. only errors after "copying" starts should be of any concern. if you could please save the output of the install script if you are having issues. this makes it much easier to troubleshoot.


usage after running install script:  

`sudo set-intel.sh` will set intel only mode, reboot and nvidia powered off and removed from view.

`sudo set-nvidia.sh`  sets intel/nvidia (prime) mode.

this should be pretty straight forward, if however, you cant figure it out, i am @dglt on the manjaro forum. 


- added side-note, for persistent changes to configurations, modify the configurations used for switching located in
 - /etc/switch/nvidia/  and  /etc/switch/intel/  

### There is now a DE/WM agnostic indicator made by linesma

This tool runs at startup and shows a tray icon showing which mode your using and allows you to switch modes easily without using CLI. 
https://github.com/linesma/manjaroptimus-appindicator
