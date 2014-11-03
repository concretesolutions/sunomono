#!/usr/bin/env bash
# ----------------------------------------------------------------------------
# Uncomment the next line to enable debug
# set -x
#
# $1 -> parameter with the path of the .app bundle

## CODE BEGIN  #############################################################

echo Start: $(date)

# Exits if the app path was not informed
if [ -z $1 ]; then
  echo "The first parameter must be the app path"
  exit 1
fi

# Reads the devices file line by line
while read line
do
  # Ignoring all comments
  echo $line | grep -q "^#" && continue

  # Reading the informations of the device in the devices file
  # The variables can't contain any kind of spaces, so we erase then off
  target="$(echo $line | cut -d'|' -f1 | tr -d ' ')"
  endpoint="$(echo $line | cut -d'|' -f2 | tr -d ' ')"
  name="$(echo $line | cut -d'|' -f3 | tr -d ' ')"

  # Cleaning the previous reports folder and ensuring its existence
  rm -rf "$WORKSPACE/reports/$name" &> /dev/null
  mkdir -p "$WORKSPACE/reports/$name" &> /dev/null

  # Navigating to the tests root folder
  cd "$WORKSPACE"

  # Executing calabash for the device
  APP_BUNDLE_PATH="$1" DEVICE_TARGET="$target" DEVICE_ENDPOINT="$endpoint" SCREENSHOT_PATH="$WORKSPACE/reports/$name/" cucumber -p ios --format 'Calabash::Formatters::Html' --out "$WORKSPACE/reports/$name/reports.html"

done < config/scripts/ios/devices

echo End: $(date)
echo 'Bye!'
## CODE END  #############################################################
