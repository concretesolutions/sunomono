#!/bin/bash
# ----------------------------------------------------------------------------
# Uncomment the next line to enable debug
# set -x
#
# $1 -> parameter with the name of the apk


# FIXME ###############
# Include loop for more than one device
#######################

## CODE BEGIN  #############################################################

# FIXME ###############
# Include if to assert that the parameter is not null or empty
#######################

echo Inicio da execução: $(date)

export DEVICE=iPhone

rm -r $WORKSPACE/reports/$DEVICE &> /dev/null
mkdir -p $WORKSPACE/reports/$DEVICE &> /dev/null

cd $WORKSPACE

APP_BUNDLE_PATH=$1 DEVICE_TARGET=000...000 DEVICE_ENDPOINT=http://0.0.0.0:37265 SCREENSHOT_PATH=$WORKSPACE/reports/$DEVICE/ cucumber -p ios --format 'Calabash::Formatters::Html' --out $WORKSPACE/reports/$DEVICE/reports.html

echo Fim da execução: $(date)
## CODE END  #############################################################
