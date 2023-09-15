#!/bin/bash

chooseFunction(){
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

# navigate to the project directory
cd $(< .project_path.txt)
# include all the functions from set_up_apps.sh
. src/set_up_apps/set_up_apps.sh
# include all the functions from prompt_user.sh
. src/prompt_user.sh
chooseFunction
