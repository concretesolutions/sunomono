#!/bin/sh

echo "Build project for calabash"

#---------------------------------------------
# For devices

xcodebuild -workspace ~/dev/idiomas-ios/tlc-idiomas.xcworkspace/ -scheme ClaroIdiomas-cal -sdk iphoneos8.1 -configuration Dev clean build
BUILT_PRODUCTS_DIR=`xcodebuild -workspace ~/dev/idiomas-ios/tlc-idiomas.xcworkspace/ -scheme ClaroIdiomas-cal -sdk iphoneos8.1 -showBuildSettings -configuration Dev | grep -i "\bbuilt_products_dir" | cut -d "=" -f2 `
#---------------------------------------------

#--------------------------------------------
# For simulator

# xcodebuild -workspace ~/dev/idiomas-ios/tlc-idiomas.xcworkspace/ -scheme ClaroIdiomas-cal -sdk iphonesimulator8.0 -configuration Dev
# BUILT_PRODUCTS_DIR=`xcodebuild -workspace ~/dev/idiomas-ios/tlc-idiomas.xcworkspace/ -scheme ClaroIdiomas-cal -sdk iphonesimulator8.0 -showBuildSettings -configuration Dev | grep -i "\bbuilt_products_dir" | cut -d "=" -f2 `
#--------------------------------------------

export APP_BUNDLE_PATH=`echo "$BUILT_PRODUCTS_DIR/ClaroIdiomas-cal.app" | tr -d ' '` 

echo $APP_BUNDLE_PATH
