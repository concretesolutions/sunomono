#!/bin/bash

# Input variables:
# $1 - The parameters of what test to execute. Example "- @dev" or "" for nothing

ambiente="CI"

cd $WORKSPACE

if [ $ambiente == "CI" ]
then
	export IOS_WORKSPACE=$WORKSPACE/../isp-participantemobile-ios-master
	ruby ./config/scripts/ios/build_app.rb jenkins simulator
	ruby ./config/scripts/ios/build_app.rb jenkins devices
fi
export LANG=en_US.UTF-8
export LANGUAGE=en_US:en


#sh $WORKSPACE/config/scripts/ios/run_tests_all_devices.sh ./app/build/ios/simulator/Gebsa-cal.app ./app/build/ios/simulator/Gebsa-cal.app
sh $WORKSPACE/config/scripts/ios/run_tests_all_devices.sh null null "$1"

# Looking inside the html tests results to see if any one of the scenarios failed and exporting an ENV variable with this result.
source ./config/scripts/check_if_tests_failed.sh

# Setting the email variable that depends on the test result status
if [ $TESTS_RESULT == "Ok" ]
then
  export STATUS_TITLE="Sucesso"
  export STATUS="\<font\ color\=\"green\"\>PASSARAM\<\/font\>"
else
	if [ $TESTS_RESULT == "Ok_with_issues" ]
	then
		export STATUS_TITLE="Sucesso"
 		export STATUS="\<font\ color\=\"green\"\>PASSARAM com ressalvas\<\/font\>"
 	else
		export STATUS_TITLE="Erro"
		export STATUS="\<font\ color\=\"red\"\>QUEBRARAM\<\/font\>"
	fi
fi
echo "o status do TESTS_RESULT é $TESTS_RESULT\n"

# Replacing the email template variables
cd ${WORKSPACE}
sed -i.bak "s/_STATUS_TITLE_/${STATUS_TITLE}/g" ./config/email/template.html
sed -i.bak "s/_STATUS_/${STATUS}/g" ./config/email/template.html
sed -i.bak "s/_JOB_NAME_/${JOB_NAME}/g" ./config/email/template.html
sed -i.bak "s/_BUILD_NUMBER_/${BUILD_NUMBER}/g" ./config/email/template.html
sed -i.bak "s/_OS_/Android/g" ./config/email/template.html


if [ $ambiente == "CI" ] 
then
# Sending the email
	# mutt -e 'set from="MacCI Jenkins <macci@concretesolutions.com.br>"' -e "set content_type=text/html" -s "Itaú Soluções - Participante Mobile - Testes BDD iOS - ${STATUS_TITLE}" itausolucoes-mobile@googlegroups.com < ./config/email/template.html
else
	mutt -e 'set from="MacCI Jenkins <macci@concretesolutions.com.br>"' -e "set content_type=text/html" -s "Assunto e o status:  ${STATUS_TITLE}" setar_aqui@setar_aqui.com < ${WORKSPACE}/config/email/template.html
fi
# Breaking the build if there was any error on the test result htmls.
bash ./config/scripts/break_build_if_failed.sh