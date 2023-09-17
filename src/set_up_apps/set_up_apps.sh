#!/bin/bash

openApps() {
    IFS=""
    local appsOptions=()
    local appsCount=0
    while read -r line; do
        appsOptions+=($line)
        (( appsCount++ ))
    done < personal_automation_info/set_up_apps.txt
    appsOptions+=("go back")
    appsOptions+=("exit")
    
    promptUser "${appsOptions[@]}" 

    read -r -p "Which app would you like to open: " appChoice

    if [[ $($appChoice == "go back" 2>/dev/null) || $($appChoice -eq $(( appsCount + 1 )) 2>/dev/null) ]]; then
        return
    elif [[ $($appChoice == "exit" 2>/dev/null) || $($appChoice -eq $(( appsCount + 2  )) 2>/dev/null) ]]; then
        exit
    # if the user types a number, then map it to the appropriate app name
    elif [[ $appChoice =~ ^[+-]?[0-9]+$ ]]; then
        # check to see if the inputted number is less than or equal to fileOrDirectoryCount to make sure it is a valid option
        if [[ $appChoice -le $appsCount && $appChoice -gt 0 ]]; then
            # if the user is using MacOS, use the open command, otherwise, run the Linux command of xdg-open
            if [[ $OSTYPE == "darwin"* ]]; then
                open -a ${appsOptions[$(( $appChoice - 1 ))]}
            else
                xdg-open ${appsOptions[$(( $appChoice - 1 ))]}
            fi
        else
            echo -e "\nInvalid selection. If you want to open a new file or directory, please make sure that the name and path are added to the \"set_up_apps.txt\" file."
            echo -e "This is what your \"set_up_apps.txt\" file has right now.\n"
            cat personal_automation_info/set_up_apps.txt
            echo -e "\n"
        fi
    # if the user types the name of the app instead, then just use the app name
    else
    # if the user is using MacOS, use the open command, otherwise, run the Linux command of xdg-open
        if [[ $OSTYPE == "darwin"* ]]; then
            open -a $appChoice
        else
            xdg-open $appChoice
        fi
    fi
}

# navigate to the project directory
cd $(< .project_path.txt)
