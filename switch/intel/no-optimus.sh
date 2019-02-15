#!/bin/sh

#this script is run as a display setup script
#that replaces the one used by nvidia/prime.
##
#this disables the nvidia dGPU and
#removes it from /sys/bus/pce/devices
#for the current boot. this is reset after reboot.
# 

xrandr --auto
echo 'auto' > '/sys/bus/pci/devices/0000:01:00.0/power/control' 

#############
##make sure the line below is the correct acpi_call to disable your nvidia gpu. to find out what call
#disables your nvidia gpu, run this ` sudo /usr/share/acpi_call/examples/turn_off_gpu.sh ` and see which acpi_call is labeled as "works!" and then uncomment and edit this file to match.

#echo '\_SB.PCI0.PEG0.PEGP._OFF' > /proc/acpi/call 
#echo -n 1 > '/sys/bus/pci/devices/0000:01:00.0/remove'
