#!/bin/bash


openWebPage() {
    IFS=","
    local nameOptions=()
    local urlOptions=()
    local browserOptions=()
    local urlCount=0
    # get the url's that the user wants to open, ignoring the first line in the file
    while read -r name url browser || [ -n "$name" ]; do
        nameOptions+=($name)
        urlOptions+=($url)
        browserOptions+=($browser)
        (( urlCount++ ))
    done < <(tail -n +2 personal_automation_info/set_up_web.csv)
    urlOptions+=("go back")
    urlOptions+=("exit")
    
    promptUser "${nameOptions[@]}"

    echo -e "\nNote: Typing the url by hand will open the webpage in your default browser. If you want the webpage to open in the specified browser, then please type the corresponding number instead."    
    read -p "Which web page would you like to open: " webChoice

    if [[ $webChoice == "go back" || $webChoice -eq $(( urlCount + 1 )) ]]; then
        return
    elif [[ $webChoice == "exit" || $webChoice -eq $(( urlCount + 2 )) ]]; then
        exit
    # if the user types a number, then map it to the appropriate url name
    elif [[ $webChoice =~ ^[+-]?[0-9]+$ ]]; then
        # check to see if the inputted number is less than or equal to urlCount to make sure it is a valid option
        if [[ $webChoice -le $urlCount && $webChoice -gt 0 ]]; then
            # if the user is using MacOS, use the open command, otherwise, run the Linux command of xdg-open
            if [[ $OSTYPE == "darwin"* ]]; then
                open -a ${browserOptions[$(( webChoice - 1 ))]} ${urlOptions[$(( $webChoice - 1 ))]}
            else
                xdg-open ${browserOptions[$(( webChoice - 1 ))]} ${urlOptions[$(( $webChoice - 1 ))]}
            fi
        else
            echo -e "\nInvalid selection. If you want to open a new file or directory, please make sure that the name and path are added to the \"set_up_web.csv\" file."
            echo -e "This is what your \"set_up_web.csv\" file has right now.\n"
            cat personal_automation_info/set_up_web.csv
            echo -e "\n"
        fi
    # if the user types the url instead, then just use the url name
    else
    # if the user is using MacOS, use the open command, otherwise, run the Linux command of xdg-open
        if [[ $OSTYPE == "darwin"* ]]; then
            open -u $webChoice
        else
            xdg-open $webChoice
        fi
    fi
}

# navigate to the project directory
cd $(< .project_path.txt)
