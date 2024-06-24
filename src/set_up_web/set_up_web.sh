#!/bin/bash

openWebPage() {
    IFS=","
    local nameOptions=()
    local urlOptions=()
    local browserOptions=()
    local urlCount=0
    # get the url's that the user wants to open, ignoring the first line in the file
    while read -r name url browser; do
        nameOptions+=($name)
        urlOptions+=($url)
        browserOptions+=($browser)
        (( urlCount++ ))
    done < <(tail -n +2 personal_automation_info/set_up_web.csv)
    urlOptions+=("go back")
    urlOptions+=("exit")
    
    promptUser "${nameOptions[@]}"
    
    echo -e "\nNote: Typing the url by hand will open the webpage in your default browser. If you want the webpage to open in the specified browser, then please type the corresponding number instead."
    read -r -p "Which web page would you like to open: " webChoice
    
    if [[ $($webChoice == "go back" 2>/dev/null) || $($webChoice -eq $(( urlCount + 1 )) 2>/dev/null) ]]; then
        return
        elif [[ $($webChoice == "exit" 2>/dev/null) || $($webChoice -eq $(( urlCount + 2 )) 2>/dev/null) ]]; then
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
# cd $(< .project_path.txt)

# CHANGE THE CODE BELOW
# Opens the web page specified as the argument
openWebPage() {
    # Set IFS to the empty string so web pages can be opened with browsers that contain a space in their name
    # Ex: "Google Chrome"
    IFS=""
    # if the user is using MacOS, use the open command, otherwise, run the Linux command of xdg-open
    if [[ $OSTYPE == "darwin"* ]]
    then
        # If a browser was specified, then open the web page using that browser, otherwise, use the default browser
        if [[ -z $2 ]]
        then
            open -u $1
        else
            open -a $2 $1
        fi
    else
        # If a browser was specified, then open the web page using that browser, otherwise, use the default browser
        if [[ -z $2 ]]
        then
            xdg-open $1
        else
            xdg-open $2 $1
        fi
        
    fi
}

# Opens all the apps listed in the file specified by the user as an argument
openAllWebPages() {
    # If a file was not specified, then list the available app options for the user
    if [[ -z $1 ]]
    then
        readarray -t webOptions < <(ls ../../personal_automation_info/web/)
        select file in ${webOptions[@]}
        do
            webFile="../../personal_automation_info/web/$file"
            break
        done
    else
        webFile="../../personal_automation_info/web/$1"
    fi
    # Open all the web pages specified in the file
    if [[ -f $webFile ]]
    then
        IFS=","
        # get the url's that the user wants to open, ignoring the first line in the file
        while read -r url browser; do
            openWebPage $url $browser
            # Reset IFS to the comma delimter since IFS is changed in the openWebPage function
            IFS=","
            sleep 1
        done < <(tail -n +2 $webFile)
    else
        echo "Not a valid file"
    fi
}

# Allows the user to create a file that specifies a list of web pages to be opened
createWebPageList() {
    # Set IFS to the empty string so web browsers with spaces in their names can be used
    # Ex: "Google Chrome"
    IFS=""
    # Specify a default value of "web_page_list" if a filename is not specified
    read -e -p "Please enter the name of your web page list file (omit the file extension) [web_page_list]: " -i "web_page_list" webListFile
    echo Url,Browser >> ../../personal_automation_info/web/$webListFile.csv
    
    read -p "Please enter the url of the web page you want to open: " webPage
    read -p "Please enter the browser that you want to open the url in. Type 'quit' to stop: " webBrowser
    while [[ ! -z $webPage && ! -z $webBrowser && $webBrowser != "quit" ]]
    do
        # Only add the web page if a non-empty string was passed
        echo $webPage,$webBrowser >> ../../personal_automation_info/web/$webListFile.csv
        read -p "Please enter the url of the web page you want to open: " webPage
        read -p "Please enter the browser that you want to open the url in. Type 'quit' to stop: " webBrowser
    done
}

createWebPageList