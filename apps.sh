#!/bin/bash

# Store the filepath of this script
dir="${BASH_SOURCE%/*}"
if [[ ! -d "$dir" ]]; then
    dir="$PWD"
fi

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
    # cd into the apps directory so only the filenames are printed instead of the full filepaths
    local originalDir=$(pwd)
    cd $dir/personal_automation_info/apps
    if [[ -z $(ls) ]]; then
        echo "The apps directory is empty. Please create an apps list file first."
        cd $originalDir
        exit 1
    fi
    local appOptions=(*)
    cd $originalDir
    
    select file in ${appOptions[@]}; do
        local appFile="$dir/personal_automation_info/apps/$file"
        break
        # Use /dev/tty to read from user input instead of stdin
    done < /dev/tty
    
    # Open all the apps specified in the file
    if [[ -f $appFile ]]; then
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
    read -e -p "Please enter the name of your apps list file (omit the file extension) [apps_list]: " appsListFile
    if [[ -z $appsListFile ]]; then
        appsListFile="apps_list"
    fi
    
    if [[ -f $dir/personal_automation_info/apps/$appsListFile.txt ]]; then
        read -p "$appsListFile.txt already exists. Do you want to overwrite it? (y/n): " overwrite
        if [[ $overwrite == "y" ]]; then
            > $dir/personal_automation_info/apps/$appsListFile.txt
        fi
    fi
    
    read -p "Please enter the name of the app you want to open. Type 'quit' to stop: " application
    while [[ ! -z $application && $application != "quit" ]]; do
        # Only add the application if a non-empty string was passed
        echo $application >> $dir/personal_automation_info/apps/$appsListFile.txt
        read -p "Please enter the name of the app you want to open. Type 'quit' to stop: " application
    done
}
