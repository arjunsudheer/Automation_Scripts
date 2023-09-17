#!bin/bash

getAutomationScriptOption() {
	while [[ true ]]; do
		# provide a list of options for the user to run automation scripts from
		local automationScripts=( "time_manager" "set_up_dev" "set_up_apps" "set_up_web" "set_up_files_and_directories" "set up automation scripts" "exit" )

		promptUser "${automationScripts[@]}"

		read -r -p "Which automation script would you like to run: " scriptOption

		# run the appropriate automation script
		case $scriptOption in
			1|"time_manager")
				echo -e "\nRunning time_manager.sh"
				bash src/time_manager.sh
				;;
			2|"set_up_dev")
				echo -e "\nRunning set_up_dev.sh"
				bash src/set_up_dev/run_set_up_dev.sh
				;;
			3|"set_up_apps")
				echo -e "\nRunning set_up_apps.sh"
				bash src/set_up_apps/run_set_up_apps.sh
				;;
			4|"set_up_web")
				echo -e "\nRunning set_up_web.sh"
				bash src/set_up_web/run_set_up_web.sh
				;;
			5|"set_up_files_and_directories")
				echo -e "\nRunning set_up_files_and_directories.sh"
				bash src/set_up_files_and_directories/run_set_up_files_and_directories.sh
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
	# keep track of whether or not files/directories were modified
	local changesMade=false
	# create the personal_automation_info directory if it does not exist
	if ! [[ -d personal_automation_info ]]; then
		mkdir personal_automation_info
		changesMade=true
	fi

	# create the neccessary files inside the personal_automation_info directory if they don't exist
	if ! [[ -f personal_automation_info/time_manager.csv ]]; then
		echo "stepName,commandName,timeInMinutes" > personal_automation_info/time_manager.csv
		changesMade=true
	fi
	if ! [[ -f personal_automation_info/set_up_dev.csv ]]; then
		echo "Name,Absolute Project Path" > personal_automation_info/set_up_dev.csv
		changesMade=true
	fi

	if ! [[ -f personal_automation_info/set_up_apps.txt ]]; then
		touch personal_automation_info/set_up_apps.txt
		changesMade=true
	fi

	if ! [[ -f personal_automation_info/set_up_files_and_directories.csv ]]; then
		echo "Name,Absolute File Path,App to Open With" > personal_automation_info/set_up_files_and_directories.csv
		changesMade=true
	fi

	if ! [[ -f personal_automation_info/set_up_web.csv ]]; then
		echo "Name,Url,Browser" > personal_automation_info/set_up_web.csv
		changesMade=true
	fi

	if [[ $changesMade == true ]]; then
		echo -e "We have finished setting things up for you. You can use our automation scripts now."
	elif [[ $1 == true ]]; then
		echo -e "Set up is already complete.\n"
	fi

	echo -e "\nPlease make sure to populate the files found in the \"personal_automation_info\" directory with the appropriate information."
}

# set IFS variable to an empty string to avoid splitting strings in substrings
IFS=""

whoami
date

automationScriptsDirectory=$(dirname $(realpath $0))
# navigate to the src directory
cd $automationScriptsDirectory

# store the path of this project in the .project_path.txt file located in the src folder
echo $automationScriptsDirectory > ".project_path.txt"
chmod u=rwx .project_path.txt

setUp
# include all the functions from prompt_user.sh
. src/prompt_user.sh
getAutomationScriptOption
