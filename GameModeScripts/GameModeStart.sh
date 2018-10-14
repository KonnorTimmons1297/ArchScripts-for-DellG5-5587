#! /bin/bash

#You can quickly jump to these sections by search for the
#number of the step follow by '@'

#1.) Run checks for Bumblebee service.
#2.) Check the loaded modules to see if nvidia is loaded
#3.) Check the current operating mode of the cpu
#4.) Set performance mode for hard drive
#5.) Try to mount the games drive

#######################################
##   1@ Checking Bumblebee Service   ##
#######################################
oSystemctlServices=$(systemctl -a)

updateSystemctlServicesVar()
{
	oSystemctlServices=$(systemctl -a)
}

tryEnableBumblebeeService()
{
	sudo systemctl enable bumblebeed.service
	updateSystemctlServicesVar
}

tryStartBumblebeeService()
{
	sudo systemctl start bumblebeed
	updateSystemctlServicesVar

	if [[ $oSystemctlServices = *active* ]]
		then
			echo "->Started Bumblebee service!"
		else
			echo "->Unable to start Bumblebee service :("
			exit 0
	fi
}

echo "==Bumblebee Service=="

if [[ $oSystemctlServices = *bumblebeed* ]]
	then
		echo "->Bumblebee enabled"

		if [[ $oSystemctlServices = *active* ]]
			then
				echo "->Bumblebee service running"
			else
				echo "->Bumblebee service not running"
				echo "->Trying to start Bumblebee service"

				tryStartBumblebeeService
		fi

	else
		echo "->Bumblebee not enabled"
		echo "->Trying to enable Bumblebee service"
		tryEnableBumblebeeService

		if [[ $oSystemctlServices = *bumblebeed* ]]
			then
				echo "->Successfully enabled Bumblebee service!"
				echo "->Trying to start Bumblebee service!"

				tryStartBumblebeeService

			else
				echo "->Unable to start Bumblebee service :("
					exit 0
		fi

fi

#################################################
##   2@ Check that nvidia modules are loaded   ##
#################################################

oLsmodNvidia=$(lsmod | grep nvidia)

updateLsmodNvidia()
{
	oLsmodNvidia=$(lsmod | grep nvidia)
}

tryLoadNvidiaModule()
{
	sudo modprobe nvidia
	updateLsmodNvidia

	if [[ $oLsmodNvidia = *nvidia* ]]
	then
		echo "->Successfully loaded the nvidia module"
	else
		echo "->Unable to load the nvidia module"
		exit 0
	fi
}

echo "==NVidia Modules=="

if [[ $oLsmodNvidia = *nvidia* ]]
then
	echo "->Nvidia Modules loaded"
else
	echo "->Nvidia modules not loaded"
	echo "->Trying to load modules"
	tryLoadNvidiaModule
fi

########################################
##   3@ Check operating mode of CPU   ##
########################################
currentCPUGovernorMode=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)

updateCurrentCPUGovernorMode()
{
	currentCPUGovernorMode=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)
}

tryTurnOnPerformanceMode()
{
	sudo cpupower frequency-set -g performance > /dev/null
	updateCurrentCPUGovernorMode

	if [[ $currentCPUGovernorMode = *performance* ]]
	then
		echo "->Successfully enabled performance mode for CPU"
	else
		echo "->Unable to enable performance mode for CPU"
	fi
}

echo "==CPU Governor=="

if [[ $currentCPUGovernorMode = *powersave* ]]
then
	echo "->CPU currently powersave mode"
	echo "->Trying to enable performance mode"

	tryTurnOnPerformanceMode
else
	echo "->CPU operating performance mode!"
fi

###################################################
##   5@ Turn on performance mode for Hard Drive  ##
###################################################
hdparmCommand=$(hdparm --version)

echo "==Hard Drive Performance mode=="

if [[ $hdparmCommand = *not\sfound* ]]
then
	echo "->hdparm not available on system"
else
	echo "->Setting HD Performance mode"
	sudo hdparm -B 250 /dev/sda > /dev/null
fi

#############################################################
##   2@ Check that Gaming Partition is correctly mounted   ##
#############################################################
oFindMountPointGamesDrive=$(findmnt /dev/sda1)

updateFindMountPointGamesDrive()
{
	oFindMountPointGamesDrive=$(findmnt /dev/sda1)
}

tryMountingGamesDrive()
{
	sudo mount -a
	updateFindMountPointGamesDrive

	if [[ $oFindMountPointGamesDrive = */home/konnor/Games* ]]
		then
			echo "->Successfully mounted Games Drive"
		else
			echo "->Unable to mount games drive :("
	fi
}

echo "==Hard Drive Mounting=="

if [[ $oFindMountPointGamesDrive = *sda1* ]]
	then
		if [[ $oFindMountPointGamesDrive = */home/konnor/Games* ]]
			then
				echo "->Games Partition mounted correctly"
			else
				echo "->Games Paritition not mounted"
				echo "->Trying to mount Games Paritition"
				tryMountingGamesDrive
		fi
	else
		echo "->Games drive not mounted"

		echo "->Trying to mount Games Paritition"
		tryMountingGamesDrive
fi