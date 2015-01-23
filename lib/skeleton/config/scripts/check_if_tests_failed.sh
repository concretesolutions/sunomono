# Looking for errors on the report files and returns an error
cd "$WORKSPACE/reports-cal"
export TESTS_RESULT=""
for folder in *
do
    if egrep '\([0-9]+ passed\)' "$folder/reports.html"
    then
	[ "$TESTS_RESULT" == "Failed" ] && continue
	export TESTS_RESULT="Ok"
    else
	export TESTS_RESULT="Failed"
    fi
done
