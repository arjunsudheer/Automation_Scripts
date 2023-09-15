#/!bin/bash

chooseFunction(){
    # navigate back to the automation scripts directory to properly execute the functions
    cd $automationScriptsDirectory

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


echo -e "Note: It is expected that you have git installed and the github CLI installed."
# get the project directory absolute path
automationScriptsDirectory=$(< .project_path.txt)
# navigate to the project directory
cd $automationScriptsDirectory
# include all the functions from set_up_dev.sh
. src/set_up_dev/set_up_dev.sh
# include all the functions from prompt_user.sh
. src/prompt_user.sh
chooseFunction
