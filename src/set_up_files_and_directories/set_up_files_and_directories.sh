#!/bin/bash

openFilesAndDirectories() {
    IFS=","
    local filesOrDirectoriesOptions=()
    local fileOrDirectoryPaths=()
    local appName=()
    local fileOrDirectoryCount=0
    # get the files or directories that the user wants to open, ignoring the first line in the file
    while read -r name path app || [ -n "$name" ]; do
        filesOrDirectoriesOptions+=($name)
        fileOrDirectoryPaths+=($path)
        appNames+=($app)           
        (( fileOrDirectoryCount++ ))
    done < <(tail -n +2 $automationScriptsDirectory/personal_automation_info/set_up_files_and_directories.csv)
    filesOrDirectoriesOptions+=("go back")
    filesOrDirectoriesOptions+=("exit")
    
    promptUser "${filesOrDirectoriesOptions[@]}" 

    echo -e "\nNote: Typing the file or directory path by hand will open the file or directory in its default application. If you want the file or directory to open in the specified application, then please type the corresponding number instead."    
    read -p "Which file or directory would you like to open: " fileOrDirectoryChoice

    if [[ $fileOrDirectoryChoice == "go back" || $fileOrDirectoryChoice -eq $(( fileOrDirectoryCount + 1 )) ]]; then
        return
    elif [[ $fileOrDirectoryChoice == "exit" || $fileOrDirectoryChoice -eq $(( fileOrDirectoryCount + 2 )) ]]; then
        exit
    # if the user types a number, then map it to the appropriate app name
    elif [[ $fileOrDirectoryChoice =~ ^[+-]?[0-9]+$ ]]; then
        # check to see if the inputted number is less than or equal to fileOrDirectoryCount to make sure it is a valid option
        if [[ $fileOrDirectoryChoice -le $fileOrDirectoryCount && $fileOrDirectoryChoice -gt 0 ]]; then
            # if the user is using MacOS, use the open command, otherwise, run the Linux command of xdg-open
            if [[ $OSTYPE == "darwin"* ]]; then
                open -a ${appNames[$(( $fileOrDirectoryChoice - 1 ))]} ${fileOrDirectoryPaths[$(( $fileOrDirectoryChoice - 1 ))]}
            else
                xdg-open ${appNames[$(( $fileOrDirectoryChoice - 1 ))]} ${fileOrDirectoryPaths[$(( $fileOrDirectoryChoice - 1 ))]}
            fi
        else
            echo -e "\nInvalid selection. If you want to open a new file or directory, please make sure that the name and path are added to the \"set_up_files_or_directories.csv\" file."
            echo -e "This is what your \"set_up_files_or_directories.csv\" file has right now.\n"
            cat personal_automation_info/set_up_files_or_directories.csv
            echo -e "\n"
        fi
    # if the user types the name of the app instead, then just use the app name
    else
    # if the user is using MacOS, use the open command, otherwise, run the Linux command of xdg-open
        if [[ $OSTYPE == "darwin"* ]]; then
            open $fileOrDirectoryChoice
        else
            xdg-open $fileOrDirectoryChoice
        fi
    fi
}

# get the project directory absolute path
automationScriptsDirectory=$(< .project_path.txt)
# navigate to the project directory
cd $automationScriptsDirectory
