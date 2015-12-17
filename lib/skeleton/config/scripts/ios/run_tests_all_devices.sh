#!/usr/bin/env bash
# ----------------------------------------------------------------------------
# Uncomment the next line to enable debug
# set -x
#
# $1 -> parameter with the path of the .app bundle for simulators
# $2 -> parameter with the path of the .app bundle for devices
# $3 -> parameter with the tests to be executed. For example: put "-t @test" or just put "" for everything


## CODE BEGIN  #############################################################
export LC_ALL="en_US.UTF-8"
echo Start: $(date)

#sets the enviroment (CI or local)
ambiente="CI"

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

# showing the versions of calabash-ios in the machine and in the app to be tested:
echo "A versão do calabash nesta máquina é:"
calabash-ios version
echo "A versão do ios-deploy é"
ios-deploy -V
echo "Listando todos os simulators disponíveis nesta máquina:"
xcrun simctl list
cd $WORKSPACE # All tests should run from the root folder of the tests project
# Setting reports_url and his tem file for use in pipe loops (while)
reports_url=""
reports_url_temp=/tmp/reports_url_temp

# Setting reports_folders and his tem file for use in pipe loops (while)
reports_folders=""
reports_folders_temp=/tmp/reports_folders_temp

# setting where de list of devices or simulators come from
devices=""
if [ $ambiente == "CI" ]
then
    devices="devices.txt"
else 
    devices="devices_local.txt"
fi
echo "A variável devices contem $devices"
echo "O ambiente é $ambiente"
echo "Associando um url para este dipositivo ou simulador \n"
cat config/scripts/ios/"$devices" |  ## Reading the devices.txt file

grep -v "#" | ## Removing the command lines
tr -d " " | ## Trimming all the spaces
while IFS='|' read UUID IP NAME TYPE
do
    #Linking an url for this device or simulator

    # reports_url="$reports_url$JOB_URL/ws/reports-cal/$NAME/reports.html "
    # reports_folders="$reports_folders$JOB_URL/ws/reports-cal/$NAME "
    mkdir -p "$reports_path"/"$NAME"/report_1/
    mkdir -p "$reports_path"/"$NAME"/report_2/

    if [ $ambiente == "CI" ]
    then
        echo motando resports_url em ambente $ambiente 
        reports_url="$reports_url""$JOB_URL""ws/reports-cal/$NAME/report_1/reports.html \t"
        reports_folders="$reports_folders""$JOB_URL""ws/reports-cal/$NAME \t"
        echo -e $reports_url > $reports_url_temp
        echo -e $reports_folders > $reports_folders_temp
        echo e ficou $reports_url
    else
        echo motando resports_url em ambente $ambiente 
        reports_url="$reports_url$WORKSPACE/reports-cal/$NAME/report_1/reports.html \t" 
        reports_folders="$reports_folders$WORKSPACE/reports-cal/$NAME \t"
        echo -e $reports_url > $reports_url_temp
        echo -e $reports_folders > $reports_folders_temp
        echo e ficou $reports_url
    fi 
done

reports_url=$(cat $reports_url_temp)
reports_folders=$(cat $reports_folders_temp)
echo depois de associar, o reports_url ficou assim: $reports_url

# All tests should run from the root folder of the tests project
cd $WORKSPACE 

echo "Entrando na rotina de testes \n"
cat config/scripts/ios/"$devices" |  ## Reading the devices.txt file

grep -v "#" | ## Removing the command lines
tr -d " " | ## Trimming all the spaces
while IFS='|' read UUID IP NAME TYPE ## Defining pipe as the separator char and reading the three variable fields
do 
    

    if [ $TYPE == "Simulator" ]
    then
	APP_PATH=$SIMULATOR_APP_PATH
    else
	APP_PATH=$DEVICE_APP_PATH
    fi
    
    # Executing calabash for the device or simulator
    echo nome: $NAME 
    echo path: $APP_PATH 
    echo executando para "$3"

    APP_BUNDLE_PATH="$APP_PATH" DEVICE_TARGET="$UUID" DEVICE_ENDPOINT="$IP" SCREENSHOT_PATH="$reports_path"/"$NAME"/report_1/ cucumber -p ios $3 --format rerun --out tmp/rerun_"$NAME".txt -f 'Calabash::Formatters::Html' -o "$reports_path"/"$NAME"/report_1/reports.html -f junit -o "$reports_path"/"$NAME"/report_1 || (echo "Retestando para $NAME: " &&  APP_BUNDLE_PATH="$APP_PATH" DEVICE_TARGET="$UUID" DEVICE_ENDPOINT="$IP" SCREENSHOT_PATH="$reports_path"/"$NAME"/report_2/ cucumber -p ios  @tmp/rerun_"$NAME".txt -f 'Calabash::Formatters::Html' -o "$reports_path"/"$NAME"/report_2/reports.html -f junit -o "$reports_path"/"$NAME"/report_2)

    # Calabash has a problem with images relative path, the command above will replace all the images path on the
    # html report file to be a relative path
    sed -i.bak 's|'"$reports_path"/"$NAME"/report_1/'||g' "$reports_path"/"$NAME"/report_1/reports.html
    sed -i.bak 's|'"$reports_path"/"$NAME"/report_2/'||g' "$reports_path"/"$NAME"/report_2/reports.html

    echo "Terminada execução para $NAME"   

done

#checking if there's any retest report and if they contain errors. If so they are referenced on the summary report...
cd "$WORKSPACE/reports-cal"
for aFolder in *
do
  
  echo  "Vamos buscar retestes em $aFolder"
  if [ -a "$aFolder/report_2/reports.html" ]  
  then     
      echo "Achou-se reports.html em $aFolder/report_2/reports.html depois de iterar na pasta de reports do device ou emulator $device \n"
      reports_url="$reports_url$aFolder/report_2/reports.html "
  fi  
done        

cd $WORKSPACE 
      
        #making the summary report
        echo O reports_url é $reports_url       
        ./config/scripts/gera_reports_html.sh $reports_url > reports-cal/reports.html

echo End: $(date)
echo 'Bye!'
## CODE END  #############################################################
