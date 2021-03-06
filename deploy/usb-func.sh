#!/bin/bash

###################################################################################
# get_usb_devices
###################################################################################
get_usb_devices()
{
	(
	root=$(mount | grep " / " | grep  -Po "(/dev/sd[^ ])")
	if [ $? -ne 0 ]; then
		root="/dev/sdx"
	fi
	
	usb_devices=(`sudo lshw 2>/dev/null | grep "bus info: usb" -A 12 | grep "logical name: /dev/sd" | \
		grep -v $root | grep -Po "(/dev/sd.*)" | sort`)
	
	echo ${usb_devices[*]}
	)
}

###################################################################################
# check_usb_device <usb_device>
###################################################################################
check_usb_device()
{
	(
	usb_device=$1
	if [ x"usb_device" = x"" ] || [ ! -b $usb_device ]; then
		echo "Device $usb_device is not exist!" ; return 1
	else
		if sudo lshw 2>/dev/null | grep "bus info: usb" -A 12 | grep "logical name: /dev/sd" | grep $usb_device >/dev/null; then
			return 0
		else
			echo "Device $usb_device is not an usb device!" ; return 1
		fi
	fi
	)
}

###################################################################################
# get_default_usb <__usb_device>
###################################################################################
get_default_usb()
{
	local __usb_device=$1
	local usb_devices=(`get_usb_devices`)
	local first_usb=${usb_devices[0]}
	if [ x"$first_usb" != x"" ]; then
		eval $__usb_device="'$first_usb'" ; return 0
	else
		return 1
	fi
}
