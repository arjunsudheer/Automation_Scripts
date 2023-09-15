# time_manager.sh

## Overview 
The time_manager.sh file is in charge of creating and executing workflows that the user can define. Each workflow will consist of the actions that the user wants to run as well as how much time the user wants to spend on each action. The time_manager.sh file will also keep track of how much time has passed, and will give 5 minute and 1 minute warnings before automatically setting up the user's workflow.

* If the time_manager.csv file has been created

    * Tell the user that they have a workflow already created and ask if they would like to build a new workflow 

        * If they want to build a new workflow, then run the createWorkflow() function 

* If the time_manager.csv file has not been created 

    * Run the createWorkflow() function 

**Required File Parameters:** None

***

## createWorkflow()  
**Parameters:** None 

* Create a csv file called "time_manager.csv" 

* Prompt until the user types "n" 

    * Prompt the user for what they want to name the current workflow step

    * Prompt until the user types "exit" 

        * Request for which functions the user wants to run 

* Request the time (in minutes) that the user wants to spend on the action 

* Append the information that the user entered into time_manager.csv
 
***

## requestWorkflowModifications() 
**Parameters:** None 

* Will prompt the user for the following modifications during the workflow execution 

    * Mute 

        * Will redirect "true" to the mute_tracker_temp.txt file to not run the 'say' command for the 5 minute and 1 minute warnings 

    * Unmute  

        * Will redirect "false" to the mute_tracker_temp.txt file to not run the run the 'say' command for the 5 minute and 1 minute warnings 

    * Add workflow command 

        * Calls the createWorkflow function

    * Add more time

        * Prompts the user for how much time they want to add to their workflow step. Redirects the current time and the additional time to the time_tracker_addition.txt file.

    * Show time left

        * Calculates the minutes left and seconds left from the current time. Tells the user how much time they have left.

    * Quit workflow

        * Calls the cleanupWorkflowFiles function
 

***

## executeWorkflow() 
**Parameters:** None 

* Will read from time_manager.csv for the appropriate commands and time frame for each workflow action 

* Execute the appropriate workflow actions 

* Call the countDown function as a background process

***

## countDown() 
**Required Parameter:** The initial time to count down from (in seconds) 

* Will count down from the specified initial time 

* At 5 minutes and 1 minute, use the 'say' command to give an audible time check for the user 

***

## cleanupWorkflowFiles()
**Parameters:** None

* Will check if the following files exist and remove them

    * time_tracker_temp.txt

    * time_tracker_addition.txt

    * background_process_info.txt

    * mute_tracker_temp.txt

* Will kill the countDown background process 


## The time_manager.csv file 
The time_manager.csv file is used to keep track of your workflows that you want to be automatically executed. The time_manager.csv file expects your workflow information in the following format. 

```workflow_step_name,workflow_function_commands (in array format),time_in_minutes```

Please **DO NOT** leave any blank lines in your file in order to follow the expected format. 