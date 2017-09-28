# Looking for errors on the report files and returns an error
if [ $TESTS_RESULT == "Failed" ] 
then
    echo "Setting build as failed"
    exit 1
fi
