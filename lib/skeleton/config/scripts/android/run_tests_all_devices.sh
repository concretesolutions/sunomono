#!/bin/bash
# ----------------------------------------------------------------------------
# Uncomment the next line to enable debug
# set -x
#
# $1 -> parameter with the name of the apk
# $2 -> parameter to indicates the tapume to run. Can be null and can have other 2 values: must or should

## CODE BEGIN  #############################################################
[ $# -lt 1 ] && echo "Wrong number of parameters." && exit 1

# Counting the number of lines returned from the command adb devices
# This command will return at least 2 as result, because of one header line and one empty line at end
# So if the result is less than or equal 2, it means that there are no devices or emulators connected
number_of_devices=$(adb devices | wc -l)
[ $number_of_devices -le 2 ] && echo "There are no devices or emulators connected!" && exit 1

echo Inicio da execução: $(date)

# Creating the reports folder for the html format
reports_path="$WORKSPACE/reports-cal"
mkdir $reports_path

for device in $(adb devices | grep "device$" | cut -f 1)
do
  cd $WORKSPACE
  # Creates the reports folder
  mkdir "$reports_path"/"$device"

  {
      ADB_DEVICE_ARG=$device calabash-android run $1 -p android SCREENSHOT_PATH="$reports_path"/"$device"/ -f 'Calabash::Formatters::Html' -o "$reports_path"/"$device"/reports.html -f junit -o "$reports_path"/"$device"
      # Calabash has a problem with images relative path, the command above will replace all the images path on the
      # html report file to be a relative path
      sed -i.bak 's|'"$reports_path"/"$device"/'||g' "$reports_path"/"$device"/reports.html
  }&

done
wait

echo Fim da execução: $(date)
## CODE END  #############################################################
