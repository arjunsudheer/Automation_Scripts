#!/bin/bash

# Opens the file or directory specified as the argument
openFilesAndDirectories() {
    # Set IFS to the empty string so files and directories that contain spaces in their names can be opened
    IFS=""
    # if the user is using MacOS, use the open command, otherwise, run the Linux command of xdg-open
    if [[ $OSTYPE == "darwin"* ]]; then
        # If an app was specified, then open the file or directory using that app, otherwise, use the default app
        if [[ -z $2 ]]; then
            open -u $1
        else
            open -a $2 $1
        fi
    else
        # If an app was specified, then open the file or directory using that app, otherwise, use the default app
        if [[ -z $2 ]]; then
            xdg-open $1
        else
            xdg-open $2 $1
        fi
    fi
}

# Opens all the files and directories listed in the file specified by the user as an argument
openAllFilesAndDirectories() {
    readarray -t fileAndDirectoryOptions < <(ls ../../personal_automation_info/file_and_directory/)
    select file in ${fileAndDirectoryOptions[@]}; do
        fdFile="../../personal_automation_info/file_and_directory/$file"
        break
    done
    
    # Open all the files and directories specified in the file
    if [[ -f $fdFile ]]; then
        IFS=","
        # get the url's that the user wants to open, ignoring the first line in the file
        while read -r path app; do
            openFilesAndDirectories $path $app
            # Reset IFS to the comma delimter since IFS is changed in the openFilesAndDirectories function
            IFS=","
            sleep 1
        done < $fdFile
    else
        echo "Not a valid file"
    fi
}

# Allows the user to create a file that specifies a list of files and directories to be opened
createFileAndDirectoryList() {
    # Set IFS to the empty string so files and directories that contain spaces in their names can be opened
    IFS=""
    # Specify a default value of "file_and_directory_list" if a filename is not specified
    read -e -p "Please enter the name of your file and directory list file (omit the file extension) [file_and_directory_list]: " -i "file_and_directory_list" fdListFile
    
    read -p "Please enter the path to the file or directory you want to open: " fdPath
    read -p "Please enter the app that you want to open the file or directory in. Type 'quit' to stop: " fdApp
    while [[ ! -z $fdPath && ! -z $fdApp && $fdApp != "quit" ]]; do
        # Only add the file or directory if a non-empty string was passed
        echo $fdPath,$fdApp >> ../../personal_automation_info/file_and_directory/$fdListFile.csv
        read -p "Please enter the path to the file or directory you want to open: " fdPath
        read -p "Please enter the app that you want to open the file or directory in. Type 'quit' to stop: " fdApp
    done
}
