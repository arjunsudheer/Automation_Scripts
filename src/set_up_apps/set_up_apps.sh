#!/bin/bash

# Opens the app specified as the argument
openApp() {
    if [[ $OSTYPE == "darwin"* ]]; then
        open -a $1
    else
        xdg-open $1
    fi
}

# Opens all the apps listed in the file specified by the user as an argument
openAllApps() {
    IFS=""
    # If a file was not specified, then list the available app options for the user
    if [[ -z $1 ]]
    then
        readarray -t appOptions < <(ls ../../personal_automation_info/apps/)
        select file in ${appOptions[@]}
        do
            appFile="../../personal_automation_info/apps/$file"
            break
        done
    else
        appFile="../../personal_automation_info/apps/$1"
    fi
    # Open all the apps specified in the file
    if [[ -f $appFile ]]
    then
        while read -r line; do
            openApp $line
            sleep 1
        done < $appFile
    else
        echo "Not a valid file"
    fi
}

# Allows the user to create a file that specifies a list of apps to be opened
createAppsList() {
    # Specify a default value of "apps_list" if a filename is not specified
    read -e -p "Please enter the name of your apps list file (omit the file extension) [apps_list]: " -i "apps_list" appsListFile
    read -p "Please enter the name of the app you want to open. Type 'quit' to stop: " application
    while [[ ! -z $application && $application != "quit" ]]
    do
        # Only add the application if a non-empty string was passed
        echo $application >> ../../personal_automation_info/apps/$appsListFile.txt
        read -p "Please enter the name of the app you want to open. Type 'quit' to stop: " application
    done
}
