# Looking for errors on the report files and returns an error
cd "$WORKSPACE/reports-cal"

export TESTS_RESULT="Ok"

for folder in *
do
   if egrep '[0-9]+ failed' "$folder/report_1/reports.html"
   then
   		if egrep '[0-9]+ failed' "$folder/report_2/reports.html"
   		then
			export TESTS_RESULT="Failed"
		else
			export TESTS_RESULT="Ok_with_issues"  # Passou na bateria de testes. Está OK, mas com ressalvas - para uso do QA...
   			echo "The test is $TESTS_RESULT"
   		fi
   fi
done
