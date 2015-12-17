#!/bin/bash
# ----------------------------------------------------------------------------
# Uncomment the next line to enable debug
# set -x
#
# $1 -> parameter with the name of the apk
# $2 -> parameter to indicates the tapume to run. Can be null and can have other 2 values: must or should
# $3 -> parameter with tests specs. For exxameple, put "feature/<feature_name>" to select an specific feature file; put "" for everything

## CODE BEGIN  #############################################################
[ $# -lt 1 ] && echo "Wrong number of parameters." && exit 1

#setting which enviroment we are dealing wiff (CI or local)
enviroment='CI'



# Counting the number of lines returned from the command adb devices
# This command will return at least 2 as result, because of one header line and one empty line at end
# So if the result is less than or equal 2, it means that there are no devices or emulators connected
number_of_devices=$(adb devices | wc -l)
[ $number_of_devices -le 2 ] && echo "There are no devices or emulators connected!" && exit 1

echo Inicio da execução: $(date)

# Creating the reports folder for the html format
reports_path="$WORKSPACE/reports-cal"
mkdir $reports_path

# Setting reports_url
reports_url=""

# Setting reports_folders
reports_folders=""

for device in $(adb devices | grep "device$" | cut -f 1)
do

  if [ $ambiente == "CI" ]
  then
    reports_url="$reports_url""$JOB_URL""ws/reports-cal/$device/report_1/reports.html "
    reports_folders="$reports_folders""$JOB_URL""ws/reports-cal/$device "
  else 
    #for use on local developer machines...
    reports_url="$reports_url$WORKSPACE/reports-cal/$device/report_1/reports.html "
    reports_folders="$reports_folders$WORKSPACE/reports-cal/$device "
  fi
done


# Starting port - can be a random port ( choosen by fair dice roll )
port=34800 

# Resigning app
calabash-android resign "$1"


for device in $(adb devices | grep "device$" | cut -f 1)
do
  cd $WORKSPACE
  # Creates the reports folder
  mkdir -p "$reports_path"/"$device"/report_1/
  mkdir -p "$reports_path"/"$device"/report_2/
  port=$((port+1)) #increase port
  {


     is_emulator=$(echo $device | grep "emulator")
      if test -n "$is_emulator"
      then
        
        echo Tentativa de destravar a tela de $device 
        #locking twice, just to guarantee (ensure they always start equally)
        adb -s $device shell input keyevent 26
        adb -s $device shell input keyevent 26

        #unlocking
        wait 2
        adb -s $device shell input keyevent 82
        adb -s $device shell input keyevent 82

      fi

      #press Home once...
      adb -s $device shell input keyevent 3

     
      # #iniciando Calabash

      echo "Inicializando Calabash para $device na porta $port "

      echo "Usando terceiro parametro $3"

      ADB_DEVICE_ARG=$device SCREENSHOT_PATH="$reports_path"/"$device"/report_1/ calabash-android run $1 -p android "$3" --format rerun --out tmp/rerun_"$device".txt -f 'Calabash::Formatters::Html' -o "$reports_path"/"$device"/report_1/reports.html -f junit -o "$reports_path"/"$device"/report_1 || (echo "Retestando para $device: " && ADB_DEVICE_ARG=$device SCREENSHOT_PATH="$reports_path"/"$device"/report_2/ calabash-android run $1 -p android @tmp/rerun_"$device".txt -f 'Calabash::Formatters::Html' -o "$reports_path"/"$device"/report_2/reports.html -f junit -o "$reports_path"/"$device"/report_2 ) 
      # Calabash has a problem with images relative path, the command above will replace all the images path on the
      # html report file to be a relative path
      sed -i.bak 's|'"$reports_path"/"$device"/report_1/'||g' "$reports_path"/"$device"/report_1/reports.html
      sed -i.bak 's|'"$reports_path"/"$device"/report_2/'||g' "$reports_path"/"$device"/report_2/reports.html

      #pressing home once... (to ensure everything else goes to background)
      adb -s $device shell input keyevent 3
  }&

done
wait

#checking if there's any retest report and if they contain errors. If so they are referenced on the summary report...
cd "$WORKSPACE/reports-cal"

for aFolder in *
do

  
  echo  "Vamos buscar retestes em $aFolder"
  if [ -a "$aFolder/report_2/reports.html" ]  
  then     
      echo "Achou-se reports.html em $aFolder/report2/reports.html depois de iterar na pasta de reports do device ou emulator $device \n"

      reports_url="$reports_url$aFolder/report_2/reports.html "
  fi  
done

cd $WORKSPACE
#making the summary report
echo "A sequencia de url ficou como: \n $reports_url"
./config/scripts/gera_reports_html.sh $reports_url > reports-cal/reports.html

echo Fim da execução: $(date)
## CODE END  #############################################################
