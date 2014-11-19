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

# Remember to install an application server to enable remote access to the reports
# Remember to previous create the reports folder and give the appropriate permissions
reports_path="/var/www/reports/$(date +"%Y%d%m")"

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
  rm -r "$reports_path"/"$name" &> /dev/null
  mkdir -p "$reports_path"/"$name" &> /dev/null

  # Navigating to the tests root folder
  cd "$WORKSPACE"

  # Executing calabash for the device
  APP_BUNDLE_PATH="$1" DEVICE_TARGET="$target" DEVICE_ENDPOINT="$endpoint" SCREENSHOT_PATH="$reports_path"/"$name"/ cucumber -p ios --format 'Calabash::Formatters::Html' --out "$reports_path"/"$name/reports.html"

done < config/scripts/ios/devices

echo End: $(date)
echo 'Bye!'
## CODE END  #############################################################
