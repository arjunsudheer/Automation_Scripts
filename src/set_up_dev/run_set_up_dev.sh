#/!bin/bash

chooseFunction(){
    # navigate back to the automation scripts directory to properly execute the functions
    cd $automationScriptsDirectory/src/set_up_dev

    # store the function options in an array
    local functionOptions=("navigateToProject" "performGithubActions" "go back" "exit")

    promptUser "${functionOptions[@]}"

    read -p "What do you want to run: " devChoice

    case $devChoice in
        1|"navigateToProject")
            navigateToProject
            ;;
        2|"performGithubActions")
            performGithubActions
            ;;
        3|"go back")
            return
            ;;
        4|"exit")
            exit
            ;;
        *)
            echo "Invalid selection. Please try again."
    esac

    # make a recursive call to let the user run more functions
    chooseFunction
}

if [[ -z "$1" ]]; then
    echo "Error in running set_up_dev.sh."
	echo "Note: You must specify the path to the automation scripts src folder as an argument."
	exit
else
    echo -e "Note: It is expected that you have git installed and the github CLI installed."
    automationScriptsDirectory=$1
    # navigate to the current project directory
    cd $automationScriptsDirectory/src/set_up_dev
    # include all the functions from set_up_dev.sh
    . set_up_dev.sh
    # include all the functions from prompt_user.sh
    . ../prompt_user.sh
    chooseFunction
fi