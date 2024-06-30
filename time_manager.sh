#!/bin/bash

# Store the filepath of this script
dir="${BASH_SOURCE%/*}"
if [[ ! -d "$dir" ]]; then
    dir="$PWD"
fi

# Prompts the user for workflow commands (functions) and stores it in the specified file
createWorkflow() {
    IFS=""
    
    read -e -p "Please enter the name of your time manager file (omit the file extension) [time_manager]: " timeManagerFile
    if [[ -z $timeManagerFile ]]; then
        timeManagerFile="time_manager"
    fi

    if [[ -f $dir/personal_automation_info/time_manager/$timeManagerFile.csv ]]; then
        read -p "$timeManagerFile.csv already exists. Do you want to overwrite it? (y/n): " overwrite
        if [[ $overwrite == "y" ]]; then
            > $dir/personal_automation_info/time_manager/$timeManagerFile.csv
        fi
    fi

    # Note: The workflowFunctions array is not creating using the "declare" keyword so that it can be unset
    local workflowFunctions=()
    local availableWorkflowCommands=(openAllApps openAllWebPages openAllFilesAndDirectories done)

    local addCommands="y"
    until [[ $addCommands == "n" ]]; do
        read -r -p "What do you want to name this workflow step: " workflowStepName
        read -r -p "How much time (in minutes) do you want to dedicate for this workflow step: " workflowStepTime
        if [[ $workflowStepTime -le 0 ]]; then
            echo "Invalid time."
            exit 1
        fi
        echo "Please pick what commands you want to run:"
        select workflowCommand in ${availableWorkflowCommands[@]}; do
            case $workflowCommand in 
                "openAllApps")
                    workflowFunctions+=(openAllApps)
                    ;;
                "openAllWebPages")
                    workflowFunctions+=(openAllWebPages)
                    ;;
                "openAllFilesAndDirectories")
                    workflowFunctions+=(openAllFilesAndDirectories)
                    ;;
                "done")
                    break
                    ;;
                *)
                    echo "Invalid option"
                    exit 1
            esac
        # Use /dev/tty to read from user input instead of stdin
        done < /dev/tty

        # Check if the lenght of the workFlowFunctions array is not 0
        if [[ ${#workflowFunctions} -ne 0 ]]; then  
            # Store the workflow step information in one variable
            workflowAddition=$workflowStepName,$workflowStepTime,${workflowFunctions[@]}
            # Append the workflowAddition variable to the time_manager.csv file
            echo $workflowAddition >> $dir/personal_automation_info/time_manager/$timeManagerFile.csv
        fi

        # Unset the workflowFunctions array for the next iteration
        unset workflowFunctions[@]

        read -r -p "Do you want to add more workflow commands? (y/n): " addCommands
    done
}

# Runs the commands for the current workflow
executeWorkflow() {
    IFS=""
    # cd into the time_manager directory so only the filenames are printed instead of the full filepaths
    originalDir=$(pwd)
    cd $dir/personal_automation_info/time_manager
    if [[ -z $(ls) ]]; then
        echo "The time_manager directory is empty. Please create a time manager workflow first."
        cd $originalDir
        exit 1
    fi
    timeManagerOptions=(*)
    cd $originalDir

    select file in ${timeManagerOptions[@]}; do
        timeManagerFile="$dir/personal_automation_info/time_manager/$file"
        break
    # Use /dev/tty to read from user input instead of stdin
    done < /dev/tty

    IFS=","
    while read -r stepName time commands; do
        echo -e "\nNow working on $stepName.\n"
        IFS=" "
        # Run each command specified in the array
        local lineFunctions=( $commands )
        for action in ${lineFunctions[@]}; do
            $action
        done

        # Convert time in minutes to seconds
        local timeLeft=$(( time * 60 ))
        # run the countDown function as a background task
        countDown $timeLeft &
        # Save the process ID of the countdown background task in the background_process_info.txt file
        echo $! > $dir/personal_automation_info/background_process_info.txt
        # If the user terminates the program (Control + C), then stop the countDown background task and cleanup temporary files
        trap cleanupWorkflowFiles SIGINT
        requestWorkflowModifications
        IFS=","
    done < $timeManagerFile
}

# Takes a required parameter that specifies how much time (in seconds) this function should count down from
countDown() {
    IFS=""
    local remainingTime=$1
    until [[ $remainingTime -le 0 ]]; do
        # Check if the time_tracker_addition.txt file has been created yet
        if [[ -f $dir/personal_automation_info/time_tracker_addition.txt ]]; then
            local remainingTime=$(< $dir/personal_automation_info/time_tracker_addition.txt)
            # Remove the time_tracker_addition.txt file to avoid adding extra time more than once
            $(rm $dir/personal_automation_info/time_tracker_addition.txt)
        fi
        sleep 1
        local mute=$(< $dir/personal_automation_info/mute_tracker_temp.txt)
        if [[ $remainingTime -eq 300 ]]; then
            if [[ $mute == false ]]; then
                $(say "You have 5 minutes left for $stepName. Please request for more time if needed.")
            fi
            echo "You have 5 minutes left for $stepName. Please request for more time if needed."
        elif [[ $remainingTime -eq 60 ]]; then
            if [[ $mute == false ]]; then
                $(say "You have 1 minute left for $stepName. Please request for more time if needed.")
            fi
            echo "You have 1 minute left for $stepName. Please request for more time if needed."
        fi
        (( remainingTime-- ))
        # Redirect the current remaining time to the "time_tracker_temp.txt" file so the remaning time can be accessed by the parent shell
        echo $remainingTime > $dir/personal_automation_info/time_tracker_temp.txt
    done
    cleanupWorkflowFiles
}

requestWorkflowModifications() {
    IFS=""
    # Set mute status to false
    echo false > $dir/personal_automation_info/mute_tracker_temp.txt

    # Wait for the "personal_automation_info/time_tracker_temp.txt" file to be created
    until [[ -f $dir/personal_automation_info/time_tracker_temp.txt ]]; do
        sleep 1
    done
    local timeLeft=$(< $dir/personal_automation_info/time_tracker_temp.txt)

    # Print the available modifications to the user
    local modifications=("mute" "unmute" "add more time" "show time left" "quit")
    local count=1
    for action in ${modifications[@]}; do
        echo "$count) $action"
        (( count++ ))
    done

    until [[ $timeLeft -le 0 ]]; do
        timeLeft=$(< $dir/personal_automation_info/time_tracker_temp.txt)
        # Prompt the user for a modification with a time limit for the remaining time left for the current task
        read -t $timeLeft -p "What modification would you like to perform: " modification
        case $modification in
            1|"mute")
                echo true > $dir/personal_automation_info/mute_tracker_temp.txt
                echo "This automation script is now muted."
                ;;
            2|"unmute")
                echo false > $dir/personal_automation_info/mute_tracker_temp.txt
                echo "This automation script is now unmuted."
                ;;
            3|"add more time")
                read -r -p "How much more time (in minutes) do you want to add: " extraTime
                local timeInSeconds=$(( extraTime * 60 ))
                timeLeft=$(< $dir/personal_automation_info/time_tracker_temp.txt)
                echo $(( timeLeft + timeInSeconds )) > $dir/personal_automation_info/time_tracker_addition.txt
                ;;
            4|"show time left")
                timeLeft=$(< $dir/personal_automation_info/time_tracker_temp.txt)
                local minutesLeft=$(( timeLeft / 60 ))
                local secondsLeft=$(( timeLeft % 60 ))
                if [[ $minutesLeft -eq 1 ]]; then
                    echo "You have $minutesLeft minute and $secondsLeft seconds left for $stepName."
                else
                    echo "You have $minutesLeft minutes and $secondsLeft seconds left for $stepName."
                fi
                ;;
            5|"quit")
                cleanupWorkflowFiles
                exit 1
                ;;
            *)
                echo -e "Invalid Modification Selected"
                ;;
        esac
    # Use /dev/tty to read from user input instead of stdin
    done < /dev/tty
}

cleanupWorkflowFiles() {
    IFS=""
    if [[ -f $dir/personal_automation_info/time_tracker_temp.txt ]]; then
        rm $dir/personal_automation_info/time_tracker_temp.txt
    fi

    if [[ -f $dir/personal_automation_info/time_tracker_addition.txt ]]; then
        rm $dir/personal_automation_info/time_tracker_addition.txt
    fi

    if [[ -f $dir/personal_automation_info/mute_tracker_temp.txt ]]; then
        rm $dir/personal_automation_info/mute_tracker_temp.txt
    fi

    if [[ -f $dir/personal_automation_info/background_process_info.txt ]]; then
        # Kill the bakground task
        local countDownPID=$(< $dir/personal_automation_info/background_process_info.txt)
        rm $dir/personal_automation_info/background_process_info.txt
        kill $countDownPID
    fi
}
   

# Set IFS variable to an empty string to avoid splitting strings in substrings
IFS=""
# Include methods from the other automation scripts bash files
. $dir/apps.sh
. $dir/web.sh
. $dir/files_and_directories.sh
