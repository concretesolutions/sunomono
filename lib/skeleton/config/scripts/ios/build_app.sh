#!/usr/bin/env bash
# ----------------------------------------------------------------------------
# Uncomment the next line to enable debug
# set -x
#
# $1 -> xcworkspace path
# $2 -> target (scheme) name created by the command calabash-ios setup
# $3 -> sdk. This will differ from simulator and device build
#       When this script was created the available sdks were: 'iphoneos8.1' for 
#       devices and iphonesimulator8.1 for simulator
# $4 -> Configuration type. Ex.: 'Dev'
# $5 -> The path to save the .app bundle

## CODE BEGIN  #############################################################

# When running on CI
# It is a good pratice to run pod install when executing this script on the CI to avoid
# building problems
# pod install

# Updating the calabash gem
#gem update calabash-cucumber

# Creating the calabash target
#(echo y; sleep 5; echo CalabashTarget-cal) | calabash-ios setup

[ $# -ne 5 ] && echo "Wrong number of parameters." && exit 1

# Creating .app bundle path folder if it doesn't exists
mkdir -p "$5"

# Changing relative to absolute path if that is the case
original_path="$(pwd)"
cd "$5"
path="$(pwd)"
cd "$original_path"

echo "Building project for calabash"

xcodebuild -workspace "$1" -scheme "$2" -sdk "$3" -configuration "$4" clean build CONFIGURATION_BUILD_DIR="$path"

echo "APP_BUNDLE_PATH=$path/$2.app"

echo End: $(date)
echo 'Bye!'
## CODE END  #############################################################
