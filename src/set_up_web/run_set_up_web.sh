#!/bin/bash

chooseFunction(){
    # store the function options in an array
    local functionOptions=("openWebPage" "go back" "exit")

    promptUser "${functionOptions[@]}"

    read -r -p "What do you want to run: " webChoice

    case $webChoice in
        "openWebPage"|1)
            openWebPage
            ;;
        "go back"|2)
            return
            ;;
        "exit"|3)
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
# include all the functions from set_up_web.sh
. src/set_up_web/set_up_web.sh
# include all the functions from prompt_user.sh
. src/prompt_user.sh
chooseFunction
