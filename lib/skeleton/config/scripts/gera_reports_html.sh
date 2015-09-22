#!/bin/bash
# make_page - A script to produce an HTML file


relatorios_1=""
relatorios_2=""

for report_file in $*
do

    if [[ $report_file == *"report_1/reports.html"* ]]
    then
            relatorios_1="$relatorios_1 <p><a href='$report_file'>$report_file</a></p>"

    fi

    if [[ $report_file == *"report_2/reports.html"* ]]
    then
            relatorios_2="$relatorios_2 <p><a href='$report_file'>$report_file</a></p>"

    fi
done

if [[ $relatorios_2 == "" ]]

then
cat <<- _EOF_
    <HTML>
    <HEAD>
        <TITLE>
        My System Information
        </TITLE>
    </HEAD>

    <BODY>
    <H1>Cucumber Report</H1>
    $relatorios_1
    </BODY>
    </HTML>
_EOF_

else

cat <<- _EOF_
    <HTML>
    <HEAD>
        <TITLE>
        My System Information
        </TITLE>
    </HEAD>

    <BODY>
    <H1>My Cucumber Report</H1>
    <H2>1st report with unexpected errors </H2>
    $relatorios_1
    <H2>2nd report with only unexpected errors retested </H2>
    $relatorios_2
    </BODY>
    </HTML>
_EOF_
fi