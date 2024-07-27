#!/bin/bash

# Store the filepath of this script
dir="${BASH_SOURCE%/*}"
if [[ ! -d "$dir" ]]; then
    dir="$PWD"
fi

# Opens the web page specified as the argument
openWebPage() {
    # Set IFS to the empty string so web pages can be opened with browsers that contain a space in their namelocal
    IFS=""
    # if the user is using MacOS, use the open command, otherwise, run the Linux command of xdg-open
    if [[ $OSTYPE == "darwin"* ]]; then
        # If a browser was specified, then open the web page using that browser, otherwise, use the default browser
        if [[ -z $2 ]]; then
            open -u $1
        else
            open -a $2 $1
        fi
    else
        # If a browser was specified, then open the web page using that browser, otherwise, use the default browser
        if [[ -z $2 ]]; then
            xdg-open $1
        else
            $2 $1
        fi
        
    fi
}

# Opens all the apps listed in the file specified by the user as an argument
openAllWebPages() {
    # cd into the web directory so only the filenames are printed instead of the full filepaths
    local originalDir=$(pwd)
    cd $dir/personal_automation_info/web
    if [[ -z $(ls) ]]; then
        echo "The web directory is empty. Please create a web list file first."
        cd $originalDir
        exit 1
    fi
    local webOptions=(*)
    cd $originalDir
    
    select file in ${webOptions[@]}; do
        local webFile="$dir/personal_automation_info/web/$file"
        break
        # Use /dev/tty to read from user input instead of stdin
    done < /dev/tty
    
    # Open all the web pages specified in the file
    if [[ -f $webFile ]]; then
        IFS=","
        # get the url's that the user wants to open, ignoring the first line in the file
        while read -r url browser; do
            openWebPage $url $browser
            # Reset IFS to the comma delimter since IFS is changed in the openWebPage function
            IFS=","
            sleep 1
        done < $webFile
    else
        echo "Not a valid file"
    fi
}

# Allows the user to create a file that specifies a list of web pages to be opened
createWebPageList() {
    # Set IFS to the empty string so web browsers with spaces in their names can be used
    IFS=""
    # Specify a default value of "web_page_list" if a filename is not specified
    read -e -p "Please enter the name of your web page list file (omit the file extension) [web_page_list]: " webListFile
    if [[ -z $webListFile ]]; then
        webListFile="web_page_list"
    fi
    
    if [[ -f $dir/personal_automation_info/web/$webListFile.csv ]]; then
        read -p "$webListFile.csv already exists. Do you want to overwrite it? (y/n): " overwrite
        if [[ $overwrite == "y" ]]; then
            > $dir/personal_automation_info/web/$webListFile.csv
        fi
    fi
    
    read -p "Please enter the url of the web page you want to open: " webPage
    read -p "Please enter the browser that you want to open the url in. Type 'quit' to stop: " webBrowser
    while [[ ! -z $webPage && ! -z $webBrowser && $webBrowser != "quit" ]]; do
        # Only add the web page if a non-empty string was passed
        echo $webPage,$webBrowser >> $dir/personal_automation_info/web/$webListFile.csv
        read -p "Please enter the url of the web page you want to open: " webPage
        read -p "Please enter the browser that you want to open the url in. Type 'quit' to stop: " webBrowser
    done
}
