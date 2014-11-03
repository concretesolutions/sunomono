#!/bin/bash
# ----------------------------------------------------------------------------
# Uncomment the next line to enable debug
# set -x
#
# $1 -> parameter with the name of the apk


## CODE BEGIN  #############################################################
echo Start: $(date)
for device in $(adb devices | grep "device$" | cut -f 1)
do
  rm -r $WORKSPACE/reports/$device &> /dev/null
  mkdir -p $WORKSPACE/reports/$device &> /dev/null
  echo $device | grep -q emulator
  # SET THE IGNORE TAGS TRUE IF THE TEST ARE RUNNING IN A DEVICE
  [ $? -ne 0 ] && ignore='--tags ~@ignore_if_test_in_device'
  cd $WORKSPACE
  ADB_DEVICE_ARG=$device SCREENSHOT_PATH=$WORKSPACE/reports/$device/ calabash-android run $1 -p android --format 'Calabash::Formatters::Html' --out $WORKSPACE/reports/$device/reports.html $ignore &
done
wait
echo End: $(date)
echo 'Bye!'
## CODE END  #############################################################
