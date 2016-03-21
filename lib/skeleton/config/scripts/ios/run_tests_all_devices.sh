#!/usr/bin/env bash
# ----------------------------------------------------------------------------
# Uncomment the next line to enable debug
# set -x
#
# $1 -> parameter with the path of the .app bundle for simulators
# $2 -> parameter with the path of the .app bundle for devices

## CODE BEGIN  #############################################################
export LC_ALL="en_US.UTF-8"
echo Start: $(date)

# Exits if the app path was not informed
[ $# -lt 2 ] && echo "Wrong number of parameters." && exit 1

# Creating the reports path
reports_path="$WORKSPACE/reports-cal"
mkdir $reports_path

# Changing relative to absolute path if that is the case
# The simulator path
original_path="$(pwd)" # Saving the original path where the command was executed
cd "$1"
SIMULATOR_APP_PATH="$(pwd)"
# The device path
cd "$original_path"
cd "$2"
DEVICE_APP_PATH="$(pwd)"

cd $WORKSPACE # All tests should run from the root folder of the tests project

cat config/scripts/ios/devices.txt |  ## Reading the devices.txt file
grep -v "#" | ## Removing the command lines
tr -d " " | ## Trimming all the spaces
while IFS='|' read UUID IP NAME TYPE ## Defining pipe as the separator char and reading the three variable fields
do 
    # Creating the report folder for this device or simulator
    mkdir "$reports_path"/"$NAME"

    if [ $TYPE == "Simulator" ]
    then
	APP_PATH=$SIMULATOR_APP_PATH
    else
	APP_PATH=$DEVICE_APP_PATH
    fi
    
    # Executing calabash for the device or simulator
    APP_BUNDLE_PATH="$APP_PATH" DEVICE_TARGET="$UUID" DEVICE_ENDPOINT="$IP" cucumber -p ios SCREENSHOT_PATH="$reports_path"/"$NAME"/ -f 'Calabash::Formatters::Html' -o "$reports_path"/"$NAME/reports.html" -f junit -o "$reports_path"/"$NAME"

    # Calabash has a problem with images relative path, the command above will replace all the images path on the
    # html report file to be a relative path
    sed -i.bak 's|'"$reports_path"/"$NAME"/'||g' "$reports_path"/"$NAME"/reports.html
done

echo End: $(date)
echo 'Bye!'
## CODE END  #############################################################
