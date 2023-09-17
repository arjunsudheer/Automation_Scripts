#!/bin/bash

createWorkflow() {
    # navigate to current project directory
    cd $automationScriptsDirectory

    IFS=""

    # Note: The workflowFunctions array is not creating using the "declare" keyword so that it can be unset
    local workflowFunctions=()
    local availableWorkflowCommands=(navigateToProject performGithubActions openApps openFilesAndDirectories openWebPage done)

    local workflowCommand="y"
    until [[ $workflowCommand == "n" ]]; do
        echo -e "\n"
        read -r -p "What do you want to name this workflow step: " workflowStepName
        while [[ true ]]; do
            promptUser "${availableWorkflowCommands[@]}"
            read -r -p "Which functions would you like to add to your workflow? Select \"done\" to stop entering functions: " workflowStep
            case $workflowStep in
                1|"navigateToProject")
                    workflowFunctions+=(openProject)
                    ;;
                2|"performGithubActions")
                    workflowFunctions+=(performGithubActions)
                    ;;
                3|"openApps")
                    workflowFunctions+=(openApps)
                    ;;
                4|"openFilesAndDirectories")
                    workflowFunctions+=(openFilesAndDirectories)
                    ;;
                5|"openWebPage")
                    workflowFunctions+=(openWebPage)
                    ;;
                6|"done")
                    break
                    ;;
                *)
                    echo "Invalid selection"
            esac
        done

        # check if the lenght of the workFlowFunctions array is not 0
        if [[ ${#workflowFunctions} -ne 0 ]]; then  
            read -r -p "How much time (in minutes) do you want to spend on this workflow step: " workflowStepTime
            # store the workflow step information in one variable
            workflowAddition=$workflowStepName,${workflowFunctions[@]},$workflowStepTime
            # append the workflowAddition variable to the time_manager.csv file
            echo $workflowAddition >> personal_automation_info/time_manager.csv
        fi

         # unset the workflowFunctions array for the next iteration
        unset workflowFunctions[@]

        echo -e "\n"
        read -r -p "Do you want to add more workflow commands? (y/n): " workflowCommand
    done
}

executeWorkflow() {
    IFS=","
    local count=1
    while read -u 9 -r stepName commandName time; do
        echo -e "\nNow working on $stepName.\n"

        # run each command specified in the array
        local lineFunctions=( $commandName )
        # set the IFS variable to a space to split the array into substrings to run each function within the array
        IFS=" "
        for command in ${lineFunctions[@]}; do
            $command
        done
        # set IFS variable back to a comma to process the next workflow step
        IFS=","
        # navigate back to the current project directory
        cd $automationScriptsDirectory

        # convert time in minutes to seconds
        local timeLeft=$(( time * 60 ))
        # run the countDown function as a background task
        countDown $timeLeft &
        # save the process ID of the countdown background task in the background_process_info.txt file
        echo $! > personal_automation_info/background_process_info.txt
        # if the user terminates the program (Control + C), then stop the countDown background task and cleanup temporary files
        trap cleanupWorkflowFiles SIGINT
        requestWorkflowModifications

        (( count++ ))
    done 9< <(tail -n +2 personal_automation_info/time_manager.csv)
}

# takes a required parameter that specifies how much time (in seconds) this function should count down from
countDown() {
    if [[ -z $1 ]]; then
        echo "You must pass an argument specifying how much time to count down from."
        return
    fi
    
    local remainingTime=$1
    until [[ $remainingTime -le 0 ]]; do
        # check if the time_tracker_addition.txt file has been created yet
        if [[ -f personal_automation_info/time_tracker_addition.txt ]]; then
            local remainingTime=$(< personal_automation_info/time_tracker_addition.txt)
            # remove the time_tracker_addition.txt file to avoid adding extra time more than once
            $(rm personal_automation_info/time_tracker_addition.txt)
        fi
        sleep 1
        local mute=$(< personal_automation_info/mute_tracker_temp.txt)
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
        # redirect the current remaining time to the "time_tracker_temp.txt" file so the remaning time can be accessed by the parent shell
        echo $remainingTime > personal_automation_info/time_tracker_temp.txt
    done
    cleanupWorkflowFiles
}

requestWorkflowModifications() {
    # set mute status to false
    echo false > personal_automation_info/mute_tracker_temp.txt

    # wait for the "personal_automation_info/time_tracker_temp.txt" file to be created
    until [[ -f personal_automation_info/time_tracker_temp.txt ]]; do
        sleep 1
    done
    local timeLeft=$(< personal_automation_info/time_tracker_temp.txt)

    local modifications=("mute" "unmute" "add workflow command" "add more time" "show time left" "quit workflow")

    promptUser "${modifications[@]}"

    # set a timeout to have the read command expire once the countdown is over
    read -r -t $timeLeft -p "Which workflow modification would you like to run: " workflowModification
    while [[ ( $workflowModification != "quit workflow" || $workflowModification -ne 5 ) && $timeLeft -ne 0 ]]; do
        case $workflowModification in
            1|"mute")
                echo true > personal_automation_info/mute_tracker_temp.txt
                echo -e "\nThis automation script is now muted."
                ;;
            2|"unmute")
                echo false > personal_automation_info/mute_tracker_temp.txt
                echo -e "\nThis automation script is now unmuted."
                ;;
            3|"add workflow command")
                createWorkflow
                ;;
            4|"add more time")
                read -r -p "How much more time (in minutes) do you want to add: " extraTime
                local timeInSeconds=$(( extraTime * 60 ))
                timeLeft=$(< personal_automation_info/time_tracker_temp.txt)
                echo $(( timeLeft + timeInSeconds )) > personal_automation_info/time_tracker_addition.txt
                ;;
            5|"show time left")
                timeLeft=$(< personal_automation_info/time_tracker_temp.txt)
                local minutesLeft=$(( timeLeft / 60 ))
                local secondsLeft=$(( timeLeft % 60 ))
                if [[ $minutesLeft -eq 1 ]]; then
                    echo -e "\nYou have $minutesLeft minute and $secondsLeft seconds left for $stepName."
                else
                    echo -e "\nYou have $minutesLeft minutes and $secondsLeft seconds left for $stepName."
                fi
                ;;
            6|"quit workflow")
                cleanupWorkflowFiles
                exit
                ;;
            *)
                echo -e "\nInvalid Modification Selected\n"
        esac
        echo -e "\n"
        if [[ -f personal_automation_info/time_tracker_temp.txt ]]; then
            timeLeft=$(< personal_automation_info/time_tracker_temp.txt)
        else
            timeLeft=0
        fi
        promptUser "${modifications[@]}"
        # set a timeout to have the read command expire once the countdown is over
        read -r -t $timeLeft -p "Which workflow modification would you like to run: " workflowModification
    done
}

cleanupWorkflowFiles() {
    if [[ -f personal_automation_info/time_tracker_temp.txt ]]; then
        $(rm personal_automation_info/time_tracker_temp.txt)
    fi

    if [[ -f personal_automation_info/time_tracker_addition.txt ]]; then
        $(rm personal_automation_info/time_tracker_addition.txtt)
    fi

    if [[ -f personal_automation_info/mute_tracker_temp.txt ]]; then
        $(rm personal_automation_info/mute_tracker_temp.txt)
    fi

    if [[ -f personal_automation_info/background_process_info.txt ]]; then
        # kill the bakground task
        local countDownPID=$(< personal_automation_info/background_process_info.txt)
        $(rm personal_automation_info/background_process_info.txt)
        $(kill $countDownPID)
    fi
}
   
# get the project directory absolute path
automationScriptsDirectory=$(< .project_path.txt)
# navigate to the project directory
cd $automationScriptsDirectory
# set IFS variable to an empty string to avoid splitting strings in substrings
IFS=""
# include the functions from set_up_dev.sh
. src/set_up_dev/set_up_dev.sh
# include the functions from set_up_apps.sh
. src/set_up_apps/set_up_apps.sh
# include the functions from set_up_web.sh
. src/set_up_web/set_up_web.sh
# include the functions from set_up_files_and_directories.sh
. src/set_up_files_and_directories/set_up_files_and_directories.sh
# include the functions from prompt_user.sh
. src/prompt_user.sh

if [[ -f personal_automation_info/time_manager.csv ]]; then
    read -r -p "It seems like you already have a workflow created. Do you want to use this workflow? (y/n): " workflowOption
    if [[ $workflowOption == 'y' ]]; then
        executeWorkflow
    elif [[ $workflowOption == 'n' ]]; then
        # truncate the "time_manager.csv" file to zero length
        : > personal_automation_info/time_manager.csv
        # add the header line specifying the columns
        echo "stepName,commands,timeInMinutes" > personal_automation_info/time_manager.csv
        createWorkflow
        executeWorkflow
    else
        echo "Invalid Selection."
    fi
else
    createWorkflow
    executeWorkflow
fi
