#!bin/bash

getAutomationScriptOption() {
	while [[ true ]]; do
		# provide a list of options for the user to run automation scripts from
		local automationScripts=( "time_manager" "set_up_dev" "set_up_apps" "set_up_web" "set_up_files_and_directories" "set up automation scripts" "exit" )

		promptUser "${automationScripts[@]}"

		read -p "Which automation script would you like to run: " scriptOption

		# run the appropriate automation script
		case $scriptOption in
			1|"time_manager")
				echo -e "\nRunning time_manager.sh"
				bash time_manager.sh $automationScriptsDirectory
				;;
			2|"set_up_dev")
				echo -e "\nRunning set_up_dev.sh"
				bash set_up_dev/run_set_up_dev.sh $automationScriptsDirectory
				;;
			3|"set_up_apps")
				echo -e "\nRunning set_up_apps.sh"
				bash set_up_apps/run_set_up_apps.sh $automationScriptsDirectory
				;;
			4|"set_up_web")
				echo -e "\nRunning set_up_web.sh"
				bash set_up_web/run_set_up_web.sh $automationScriptsDirectory
				;;
			5|"set_up_files_and_directories")
				echo -e "\nRunning set_up_files_and_directories.sh"
				bash set_up_files_and_directories/set_up_files_and_directories.sh $automationScriptsDirectory
				;;
			6|"set up automation scripts")
				setUp true
				# make a recursive call so the user can select another script to run
				getAutomationScriptOption
				;;
			7|"exit")
				exit
				;;
			*)
				echo -e "\nInvalid selection. Please pick an option provided."
		esac
	done
}

# parameter specifies if this function was invoked from getAutomationScriptOption() 
setUp() {
	# keep track of whethre or not files/directories were modified
	local changesMade=false
	# create the personal_automation_info directory if it does not exist
	if ! [[ -d $automationScriptsDirectory/personal_automation_info ]]; then
		mkdir $automationScriptsDirectory/personal_automation_info
		changesMade=true
	fi

	# create the neccessary files inside the personal_automation_info directory if they don't exist
	if ! [[ -f $automationScriptsDirectory/personal_automation_info/time_manager.csv ]]; then
		$automationScriptsDirectory/personal_automation_info/time_manager.csv > "stepName,commandName,timeInMinutes"
		changesMade=true
	fi
	if ! [[ -f $automationScriptsDirectory/personal_automation_info/set_up_dev.csv ]]; then
		$automationScriptsDirectory/personal_automation_info/set_up_dev.csv > "Name,Absolute Project Path"
		changesMade=true
	fi

	if ! [[ -f $automationScriptsDirectory/personal_automation_info/set_up_apps.txt ]]; then
		touch $automationScriptsDirectory/personal_automation_info/set_up_apps.txt
		changesMade=true
	fi

	if ! [[ -f $automationScriptsDirectory/personal_automation_info/set_up_files.csv ]]; then
		$automationScriptsDirectory/personal_automation_info/set_up_files.csv > "Name,Absolute File Path,App to Open With"
		changesMade=true
	fi

	if ! [[ -f $automationScriptsDirectory/personal_automation_info/set_up_web.csv ]]; then
		$automationScriptsDirectory/personal_automation_info/set_up_web.csv > "Name,Url,Browser"
		changesMade=true
	fi

	if [[ $changesMade == true ]]; then
		echo -e "We have finished setting things up for you. You can use our automation scripts now."
	elif [[ $1 == true ]]; then
		echo -e "Set up is already complete.\n"
	fi

	echo -e "\nPlease make sure to populate the files found in the \"personal_automation_info\" directory with the appropriate information."
}

if [[ -z "$1" ]]; then
	echo "Error in running main.sh."
	echo "Note: You must specify the path to the automation scripts src folder as an argument."
	exit
else
	# set IFS variable to an empty string to avoid splitting strings in substrings
	IFS=""

	whoami
	date

	# navigate to the project directory
	automationScriptsDirectory=$1
	cd $automationScriptsDirectory/src

	setUp
	# include all the functions from prompt_user.sh
    . prompt_user.sh
	getAutomationScriptOption
fi