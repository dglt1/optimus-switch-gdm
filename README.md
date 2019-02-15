# optimus-switch-gdm
- this is a modified and more complete version of my lightDM scripts, made to work with gdm/gnome. includes install - script. made for manjaro linux.
- this install script and accompanying scripts/.conf files will setup an intel/nvidia PRIME setup that will provide
- the best possible performance for your intel/nvidia optimus laptop. this will also allow for switching between
- intel/nvidia (prime) mode and an intel only mode that also completely powers down and removes the nvidia gpu
- from sight allowing for improved battery life.

  - this script by default is for an intel gpu with a BusID 0:2:0
  - and an nvidia gpu with BusID 01:00:0`
  - you can verify this in terminal with this command `lspci | grep -E 'VGA|3D'`
  - if yours do not match, edit ~/optimus-switch-gdm/switch/intel/intel-xorg.conf to match your BusID
  - and ~/optimus-switch-gdm/switch/nvidia/nvidia-xorg.conf  to match your nvidia BusID
  - DO THIS BEFORE RUNNING INSTALL SCRIPT, if you want it to work anyway.
  - note: output like this "00:02.0 VGA " has to look like this 0:2:0 in the .conf for it to work.


Lets begin.
- requirements:
 - check `mhwd -li` to see what video drivers are installed, for this to work, you need only
 - video-nvidia installed, if you have others, start by removing them like this.
 - `sudo mhwd -r pci name-of-video-driver`
- if you dont already have video-nvidia installed, do that now:
- `sudo mhwd -i pci video-nvidia`
then:
 - `sudo pacman -S acpi_call-dkms xf86-video-intel git`
 - `sudo modprobe acpi_call`

after your sure all gpu related configurations/blacklists are removed, continue:
in terminal, from your home directory ~/  (this is important for the install script to work properly)

- `git clone https://github.com/dglt1/optimus-switch-gdm.git`
- `cd optimus-switch-gdm`
- `sudo ./install.sh`
- `sudo set-intel.sh`
or
- `sudo set-nvidia.sh`
- 
- Done!
-
switch as often as you like. i installed a fresh gnome earlier just to be sure the setup scripts work and install as they should and it worked out perfectly, both intel mode and prime mode work without any issues.

- you may notice that after you boot into the intel only mode that the nvidia gpu is not yet disabled and its because you - cant run a proper test while running prime that involves disable the nvidia driver (it hard locks up the system).

- so once your booted into an intel only session run this in terminal:
- `/usr/share/acpi_call/examples/turn_off_gpu.sh`

you should see a list of various acpi calls, find the one that says “works!” , copy it. and then:
sudo nano /etc/switch/intel/no-optimus.sh

at the bottom you will see 2 lines #commented out, uncomment them (remove #) and if the acpi call is different from the one you just copied, edit/replace with the good one. save/exit.

then:

sudo set-intel.sh
reboot

the nvidia gpu should be disabled and no longer visible. let me know how it goes, if you notice anything that could be improved upon.

note: if you see errors about “file does not exist” when you run install.sh its because it’s trying to remove the usual mhwd-gpu/nvidia files that you may/may not have removed. only errors after "copying " starts should be of any concern. if you could anyway please post the output of the install script.


usage after running install script:  

`sudo set-intel.sh` will set intel only mode, reboot and nvidia powered off and removed from view.

`sudo set-nvidia.sh`  sets intel/nvidia (prime) mode.

this should be pretty straight forward, if however, you cant figure it out, i am @dglt on the manjaro forum. 
