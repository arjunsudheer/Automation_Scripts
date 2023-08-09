# run_set_up_apps.sh

## Overview
The run set_up_apps.sh file is in charge of running set_up_apps.sh when the user wants to run a command from set_up_apps.sh. This file will not be used for an automated call for set_up_apps.sh.

**Required File Parameters:** This file takes a required parameter that specifies the path to the project folder.

## chooseFunction() 
**Parameters:** None

* Prints the available functions within set_up_apps.sh to run 

* Asks the user what function they want to run 

* Runs the appropriate function 

* Makes a recursive call for the user to keep running functions until they exit the script or go back to the previous step