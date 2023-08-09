# main.sh Documentation

## Overview
The main.sh file is the center of the automation scripts project. This file is what will run other files and should be where the user starts. main.sh is in charge of prompting the user regarding which automation script they want to run. It will also check if set up has been completed, and if it isn't, it will set up the project by creating the personal_automation_info directory and the respective text files within it.

**Required File Parameters:** This file takes a required parameter that specifies the path to the project folder.

***

## setUp() function
**Optional parameter:** Specifies if this function was invoked from getAutomationScriptOption(). Can be true or false.

* Checks to see if the personal_automation_info directory exists. If it does not exist, then create the directory.

* Checks to see if the files inside of the personal_automation_info directory exists. If any file does not exist, then create the respective file.

***

## getAutomationScriptOption() function
**Parameters:** None

* Provide a list of options for the user to run automation scripts from 

* Run the appropriate automation script specified from user input 

    * If the user makes an invalid selection, make a recursive function call to make the user select a valid option 

    * If the user selects the exit option, then exit the script