# set_up_dev.sh Documentation

## Overview
The set_up_dev.sh file is in charge of navigating to projects given a file path to the project and executing git commands and github commands via the github CLI. This file will help developers.  

**Required File Parameters:** None

***

## navigateToProject()
**Parameters:** None

* Will read the project name and the project path from the set_up_dev.csv file

* Print the available projects for the user to pick from, and prompt the user to pick which project they want to open.

* Navigate to the appropriate project given the prjoect name and the path (which is found in set_up_dev.csv). 

***
 
## performGithubActions() 
**Optional Parameters:** The command you want to run

If no parameter is specified, this function will give options for the user to select which command they want to run, and will prompt them with the appropriate messages to properly execute the statement. 

If a parameter is specified, this function will bypass the user prompts and instead directly execute the specified command.

The following are the commands that are executable via set_up_dev.sh:

* Pull (git pull) 

* Add (git add) 

    * Will ask for a list of files to add

* Commit (git commit) 

    * Will ask for commit message 

* Push (git push) 

    * Will perform the same actions as git commit, put additionally push to remote repository 

* switch branch

    * Will propmt for the name of the branch the user wants to switch into 

* Open pull request 

    * Will use github CLI to open a new pull request with a specified body and title 

* Merge (using github CLI, will merge two branches) 

    * Will ask for the branch to merge with main 

# The set_up_dev.csv file
The set_up_dev.csv file is used to keep track of your projects and the paths to your projects. It is expected that you enter projects and project path names into set_up_dev.csv in the following format.

```project_name,path_to_project```

Please **DO NOT** leave any blank lines in your file in order to follow the expected format. Also, please make sure that your path names are absolute paths and not relative paths. This ensures that we can access your project regardless of our location in your computer's file system.