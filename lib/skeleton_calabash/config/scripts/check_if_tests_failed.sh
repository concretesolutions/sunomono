# Looking for errors on the report files and returns an error
cd "$WORKSPACE/reports-cal"

export TESTS_RESULT="Ok"
for folder in *
do
    if egrep '[0-9]+ failed' "$folder/reports.html"
    then
	export TESTS_RESULT="Failed"
    fi
done
