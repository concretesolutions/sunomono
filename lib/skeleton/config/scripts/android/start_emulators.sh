#!/bin/bash
# Author: Victor Nascimento

bash stop_emulators.sh 

# Suffix name of the AVD
SUFFIX="CALABASH_AVD_4."

# All $SUFFIX emulators are started
for AVD in ${HOME}/.android/avd/${SUFFIX}*.avd
do
    # remove any locks that were left
    rm "$AVD/*.lock" 2> /dev/null
    # takes only the name of the AVD
    echo $AVD
    AVD="$(basename ${AVD/.avd/})" 
    echo starting "$AVD"... 
    emulator -wipe-data -gpu on -noaudio -scale 0.5 -no-boot-anim -accel on -avd "$AVD" -qemu -m 1024 -enable-kvm &
done

sleep 15
# lists all emulators with adb and check for its online state

# finds the port through adb emulator name
for porta in $(adb devices -l | grep ^emulator | cut -d " " -f 1 | cut -d - -f 2)
do
    echo Searching for emulator PID for port: ${porta}
    pid=$(netstat -tlnp 2> /dev/null | grep "$porta" | tr -s " " | cut -d " " -f 7 | cut -d "/" -f 1)
    echo gets the AVD name from the exec command
    avd=$(ps -ef | grep -v grep | grep "$pid" | egrep -o '\-avd .*' | cut -d " " -f 2)
    echo AVD: ${avd}
    # if name contains suffix
    if echo "$avd" | grep -q "$SUFFIX"
    then
	echo Waiting for "emulator-${porta}:${avd}" to be ready

	# Wait for online state with maximum 60 tries
	COUNT=0
	
	while adb -s "emulator-${porta}" shell getprop dev.bootcomplete | grep -q error 
	do
	    if [ "$COUNT" -eq 60 ]
	    then
		echo "Emulator took too long to start up"
		exit 1
	    fi

	    let COUNT++
	    sleep 1
	done
    fi
done
