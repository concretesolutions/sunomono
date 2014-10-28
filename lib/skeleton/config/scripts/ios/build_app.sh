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

## CODE BEGIN  #############################################################

[ $# -ne 4 ] && echo "Wrong number of parameters." && exit 1

echo "Building project for calabash"

xcodebuild -workspace "$1" -scheme "$2" -sdk "$3" -configuration "$4" clean build

BUILT_PRODUCTS_DIR=`xcodebuild -workspace "$1" -scheme "$2" -sdk "$3" -showBuildSettings -configuration "$4" | 
                    grep -i "\bbuilt_products_dir" | 
                    cut -d "=" -f2 `

export APP_BUNDLE_PATH=`echo "$BUILT_PRODUCTS_DIR/$2.app" | 
                        sed 's/^\ *//g' |
                        sed 's/\ *$//g'`

echo $APP_BUNDLE_PATH

echo End: $(date)
echo 'Bye!'
## CODE END  #############################################################