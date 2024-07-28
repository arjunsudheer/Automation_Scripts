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
. $dir/time_manager.sh

# Define help message function
help() {
    echo "Help for automation scripts"
    echo "Specify the mode with the following options: -a (apps), -f (files and directories), -w (web)"
    echo "To create a new time manager workflow, use the -t flag"
    echo -e "\n"
    echo "-A Opens all apps/files/directories/webpages in a specified file. Automation scripts will prompt you to select a file."
    echo "-C Creates an apps/files/directories/webapges list file that can then be used with the -a option described above."
    echo "-O Opens the specified app/file/directory/webpage in it's default app or browser. Required argument specifying the app/file/directory/webpage you want to open."
    echo -e "\n"
    echo -e "Specifying no options will cause Automation Scripts to prompt you to pick a time manager workflow to start.\n"
}

# Assigns the mode, action, and argument variables based on the options that the user specifies
while getopts ":afwthACO:" option; do
    case $option in
        a) mode="app" ;;
        f) mode="fd" ;;
        w) mode="web" ;;
        t) mode="timeManager" ;;
        h) mode="help" ;;
        A) action="openAll" ;;
        C) action="create" ;;
        O)
            action="openOne"
            argument=$OPTARG
        ;;
        ?)
            echo -e "Invalid option $OPTARG\n"
            help
            exit 1
        ;;
    esac
done

# Calls the appropriate function based on the options specified by the user
case $mode in
    "app")
        if [[ $action == "openAll" ]]; then
            openAllApps
            elif [[ $action == "create" ]]; then
            createAppsList
            elif [[ $action == "openOne" ]]; then
            openApp $argument
        else
            echo -e "Please specify a valid action\n"
            help
            exit 1
        fi
    ;;
    "fd")
        if [[ $action == "openAll" ]]; then
            openAllFilesAndDirectories
            elif [[ $action == "create" ]]; then
            createFileAndDirectoryList
            elif [[ $action == "openOne" ]]; then
            openFilesAndDirectories $argument
        else
            echo -e "Please specify a valid action\n"
            help
            exit 1
        fi
    ;;
    "web")
        if [[ $action == "openAll" ]]; then
            openAllWebPages
            elif [[ $action == "create" ]]; then
            createWebPageList
            elif [[ $action == "openOne" ]]; then
            openWebPage $argument
        else
            echo -e "Please specify a valid action\n"
            help
            exit 1
        fi
    ;;
    "timeManager")
        createWorkflow
    ;;
    "help")
        help
    ;;
    *)
        if [[ -z $action ]]; then
            executeWorkflow
        else
            echo -e "Invalid options\n"
            help
            exit 1
        fi
    ;;
esac
