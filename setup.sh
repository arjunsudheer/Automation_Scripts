#!/bin/bash

# Store the filepath of this script
dir="${BASH_SOURCE%/*}"
if [[ ! -d "$dir" ]]; then
    dir="$PWD"
fi

# Create the personal_automation_info directory if it does not exist
if ! [[ -d $dir/personal_automation_info ]]; then
    mkdir $dir/personal_automation_info
fi

# Create the neccessary files inside the personal_automation_info directory if they don't exist
if ! [[ -d $dir/personal_automation_info/apps ]]; then
    mkdir $dir/personal_automation_info/apps
fi
if ! [[ -d $dir/personal_automation_info/web ]]; then
    mkdir $dir/personal_automation_info/web
fi

if ! [[ -d $dir/personal_automation_info/file_and_directory ]]; then
    mkdir $dir/personal_automation_info/file_and_directory
fi

if ! [[ -d $dir/personal_automation_info/time_manager ]]; then
    mkdir $dir/personal_automation_info/time_manager
fi
