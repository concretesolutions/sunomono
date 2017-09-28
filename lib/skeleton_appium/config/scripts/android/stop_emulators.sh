#!/bin/bash
# Author: Victor Nascimento

SUFFIX=CALABASH_AVD_4.

for AVD in $HOME/.android/avd/${SUFFIX}*.avd
do 
    AVD="$(basename ${AVD/.avd/})" 
    echo chuck killing "$AVD"... 
    pkill -9 -f "$AVD"
done


