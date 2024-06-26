#!/bin/bash


# Store the filepath of this script
dir="${BASH_SOURCE%/*}"
if [[ ! -d "$dir" ]]; then
    dir="$PWD"
fi

# Create the personal_automation_info directories if they are not already created
. $dir/setup.sh

# Include methods from the other automation scripts bash files
. $dir/apps.sh
. $dir/web.sh
. $dir/files_and_directories.sh

# Define help message function
help() {
    echo "Help for automation scripts"
    echo "Specify the mode with the following options: -A (apps), -F (files and directories), -W (web)"
    echo -e "\n"
    echo "-a Opens all apps/files/directories/webpages in a specified file. Automation scripts will prompt you to select a file."
    echo "-c Creates an apps/files/directories/webapges list file that can then be used with the -a option described above."
    echo "-o Opens the specified app/file/directory/webpage in it's default app or browswer. Required argument specifying the app/file/directory/webpage you want to open."
}

mode=""
action=""
argument=""
while getopts ":AWFacho:" option; do
    case $option in
        A) mode="app" ;;
        F) mode="fd" ;;
        W) mode="web" ;;
        a) action="openAll" ;;
        c) action="create" ;;
        o)
            action="openOne"
            argument=$OPTARGS
        ;;
        h) help ;;
        ?)
            echo -e "Invalid option $OPTARG\n"
            help
            exit 1
        ;;
    esac
done

case $mode in
    "app")
        if [[ $mode == "openAll" ]]; then
            openAllApps
            elif [[ $action == "create" ]]; then
            createAppsList
            elif [[ $mode == "openOne" ]]; then
            openApps $argument
        else
            echo -e "Please specify a valid action\n"
            help
            exit 1
        fi
    ;;
    "fd")
        if [[ $mode == "openAll" ]]; then
            openAllFilesAndDirectories
            elif [[ $action == "create" ]]; then
            createFileAndDirectoryList
            elif [[ $mode == "openOne" ]]; then
            openFilesAndDirectories $argument
        else
            echo -e "Please specify a valid action\n"
            help
            exit 1
        fi
    ;;
    "web")
        if [[ $mode == "openAll" ]]; then
            openAllWebPages
            elif [[ $action == "create" ]]; then
            createWebPageList
            elif [[ $mode == "openOne" ]]; then
            openWebPage $argument
        else
            echo -e "Please specify a valid action\n"
            help
            exit 1
        fi
    ;;
    *)
        echo -e "Invalid options\n"
        help
        exit 1
    ;;
esac
