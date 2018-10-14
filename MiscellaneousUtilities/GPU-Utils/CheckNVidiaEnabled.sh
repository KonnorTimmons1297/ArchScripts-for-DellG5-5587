#!/bin/bash

bbswitch_status=$(cat /proc/acpi/bbswitch)

if grep -s "ON" $bbswitch_status
then
	echo "NVidia Card is enabled"
else
	echo "Nvidia Card is disabled"	
fi
