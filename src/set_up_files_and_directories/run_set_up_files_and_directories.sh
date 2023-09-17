#!/bin/bash

chooseFunction(){
    # store the function options in an array
    local functionOptions=("openFilesAndDirectories" "go back" "exit")

    promptUser "${functionOptions[@]}"

    read -r -p "What do you want to run: " fileOrDirectoryOption

    case $fileOrDirectoryOption in
        1|"openFilesAndDirectories")
            openFilesAndDirectories
            ;;
        2|"go back")
            return
            ;;
        3|"exit")
            exit
            ;;
        *)
            echo "Invalid selection. Please try again."
    esac

    # make a recursive call to let the user run more functions
    chooseFunction
}


# navigate to the project directory
cd $(< .project_path.txt)
# include all the functions from set_up_apps.sh
. src/set_up_files_and_directories/set_up_files_and_directories.sh
# include all the functions from prompt_user.sh
. src/prompt_user.sh
chooseFunction
