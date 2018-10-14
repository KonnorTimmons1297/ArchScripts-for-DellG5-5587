#! /bin/bash

#You can quickly jump to these sections by search for the 
#number of the step follow by '@'

#1.) Remove the loaded nvidia modules and check that it is off
#2.) Change the CPU governor mode back to powersave
#3.) Turn on agressive power saving for hard drive

#################################################
##   1@ Check that nvidia modules are loaded   ##
#################################################

oLsmodNvidia=$(lsmod | grep nvidia)

updateLsmodNvidia()
{
	oLsmodNvidia=$(lsmod | grep nvidia)
}
tryUnloadNvidiaModule()
{
	sudo modprobe -r nvidia_modeset
	sudo modprobe -r nvidia
	updateLsmodNvidia

	if [[ $oLsmodNvidia = *nvidia* ]]
	then
		echo "Failed to unload nvidia module"
	else
		echo "Nvidia Modules Unloaded correctly"
	fi
}

if [[ $oLsmodNvidia = *nvidia* ]]
then
	echo "Unloading Nvidia Modules"
	tryUnloadNvidiaModule
else
	echo "Nvidia modules not loaded"
fi

########################################
##   2@ Check operating mode of CPU   ##
########################################
currentCPUGovernorMode=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)

updateCurrentCPUGovernorMode()
{
	currentCPUGovernorMode=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)
}

tryTurnOnPowersaveMode()
{
	sudo cpupower frequency-set -g powersave &

	if [[ $currentCPUGovernorMode = *powersave* ]]
	then
		echo "Successfully enabled powersave mode for CPU"
	else
		echo "Unable to enable powersave mode for CPU"
	fi
}

if [[ $currentCPUGovernorMode = *performance* ]]
then
	echo "CPU currently in performance mode"
	tryTurnOnPowersaveMode
else
	echo "CPU is operating in powersave!"
fi

###################################################
##   3@ Turn off performance mode for Hard Drive  ##
###################################################
echo "Setting HD Powersaving mode"
sudo hdparm -B 10 /dev/sda > /dev/null
