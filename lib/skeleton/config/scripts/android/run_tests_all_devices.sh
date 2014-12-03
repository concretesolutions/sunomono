#!/bin/bash
# ----------------------------------------------------------------------------
# Uncomment the next line to enable debug
# set -x
#
# $1 -> parameter with the name of the apk


## CODE BEGIN  #############################################################
[ $# -ne 1 ] && echo "Wrong number of parameters." && exit 1

# Counting the number of lines returned from the command adb devices
# This command will return at least 2 as result, because of one header line and one empty line at end
# So if the result is less than or equal 2, it means that there are no devices or emulators connected
number_of_devices=$(adb devices | wc -l)
[ $number_of_devices -le 2 ] && echo "There are no devices or emulators connected!" && exit 1

echo Inicio da execução: $(date)

reports_path="$WORKSPACE/reports-cal"
mkdir $reports_path

for device in $(adb devices | grep "device$" | cut -f 1)
do
  # Cleaning the previous reports folder and ensuring its existence when running in dev machine
  #rm -r "$reports_path"/"$device" &> /dev/null
  #mkdir -p "$reports_path"/"$device" &> /dev/null
  echo $device | grep -q emulator
  # SET THE IGNORE TAGS TRUE IF THE TEST ARE RUNNING IN A DEVICE
  [ $? -ne 0 ] && ignore='--tags ~@ignore_if_test_in_device'
  cd $WORKSPACE
  ADB_DEVICE_ARG=$device SCREENSHOT_PATH="$reports_path"/"$device"/ calabash-android run $1 -p android --format 'Calabash::Formatters::Html' --out "$reports_path"/"$device"/reports.html $ignore &
done
wait

# Calabash has a problem with images relative path, the command above will replace all the images path on the
# html report file to be a relative path
for device in $(adb devices | grep "device$" | cut -f 1)
do
  sed -i 's|'"$reports_path"/"$device"/'||g' "$reports_path"/"$device"/reports.html
done
echo Fim da execução: $(date)
## CODE END  #############################################################
