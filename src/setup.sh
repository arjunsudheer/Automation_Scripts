#!/bin/bash


# Store the filepath of this script
dir="${BASH_SOURCE%/*}"
if [[ ! -d "$dir" ]]; then
    dir="$PWD"
fi

# create the personal_automation_info directory if it does not exist
if ! [[ -d $dir/../personal_automation_info ]]; then
    mkdir personal_automation_info
fi

# create the neccessary files inside the personal_automation_info directory if they don't exist
if ! [[ -d $dir/../personal_automation_info/apps ]]; then
    mkdir $dir/../personal_automation_info/apps
fi
if ! [[ -d $dir/../personal_automation_info/web ]]; then
    mkdir $dir/../personal_automation_info/web
fi

if ! [[ -d $dir/../personal_automation_info/file_and_directory ]]; then
    mkdir $dir/../personal_automation_info/file_and_directory
fi

# if ! [[ -d $dir/../personal_automation_info/set_up_files_and_directories.csv ]]; then
#     echo $dir/../"Name,Absolute File Path,App to Open With" > personal_automation_info/set_up_files_and_directories.csv
# fi
