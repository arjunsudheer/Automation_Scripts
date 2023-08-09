#!/bin/bash

chooseFunction(){
    # navigate back to the automation scripts directory to properly execute the functions
    cd $automationScriptsDirectory/src/set_up_apps

    # store the function options in an array
    local functionOptions=("openApps" "go back" "exit")

    promptUser "${functionOptions[@]}"

    read -p "What do you want to run: " appChoice

    case $appChoice in
        1|"openApps")
            openApps
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

if [[ -z "$1" ]]; then
    echo "Error in running run_set_up_apps.sh."
	echo "Note: You must specify the path to the automation scripts src folder as an argument."
	exit
else
    automationScriptsDirectory=$1
    # navigate to the current project directory
    cd $automationScriptsDirectory/src/set_up_apps
    # include all the functions from set_up_apps.sh
    . set_up_apps.sh
    # include all the functions from prompt_user.sh
    . ../prompt_user.sh
    chooseFunction
fi