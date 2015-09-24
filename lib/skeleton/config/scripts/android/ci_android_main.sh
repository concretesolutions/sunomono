export reports_path="$WORKSPACE/reports-cal"

# Input variables:
# $1 - The parameters of what test to execute. Example "- @dev" or "" for nothing

#bash $WORKSPACE/config/scripts/android/start_emulators.sh

bash $WORKSPACE/config/scripts/android/run_tests_all_devices.sh $WORKSPACE/app/build/outputs/apk/app-gebsaprev-homolog.apk "" $1

# Looking inside the html tests results to see if any one of the scenarios failed and exporting an ENV variable with this result.
source $WORKSPACE/config/scripts/check_if_tests_failed.sh

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
sed -i.bak "s/_STATUS_TITLE_/${STATUS_TITLE}/g" ${WORKSPACE}/config/email/template.html
sed -i.bak "s/_STATUS_/${STATUS}/g" ${WORKSPACE}/config/email/template.html
sed -i.bak "s/_JOB_NAME_/${JOB_NAME}/g" ${WORKSPACE}/config/email/template.html
sed -i.bak "s/_BUILD_NUMBER_/${BUILD_NUMBER}/g" ${WORKSPACE}/config/email/template.html
sed -i.bak "s/_OS_/Android/g" ${WORKSPACE}/config/email/template.html

echo "Enviando e-mail\n"

# Sending the email (descomentar para quando for rodar em homolog/prod)
mutt -e 'set from="MacCI Jenkins <macci@concretesolutions.com.br>"' -e "set content_type=text/html" -s "Assunto e o status:  ${STATUS_TITLE}" setar_aqui@setar_aqui.com < ${WORKSPACE}/config/email/template.html


# Breaking the build if there was any error on the test result htmls.
bash $WORKSPACE/config/scripts/break_build_if_failed.sh