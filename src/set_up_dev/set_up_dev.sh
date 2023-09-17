#!/bin/bash

navigateToProject() {
    IFS=","
    # navigate to the current project directory
    cd $automationScriptsDirectory
    # array to store all the available projects
    declare -a projectNames
    # array to store all the available project paths
    declare -a projectPaths
    # read from the set_up_dev.txt file to see what projects options the user has given
    local projectCount=0
    while read -r name path; do
        projectNames+=($name)
        projectPaths+=($path)
        (( projectCount++ ))
    done < <(tail -n +2 personal_automation_info/set_up_dev.csv)
	projectNames+=("go back")
    projectNames+=("exit")

    promptUser "${projectNames[@]}"
    read -r -p "Which project would you like to navigate into: " devOption

    # if the user types a number, then map it to the appropriate project name
    local pathName="null"
    if [[ $devOption -eq $(( projectCount + 1 )) || $devOption == "go back" ]]; then
        return
    elif [[ $devOption -eq $(( projectCount + 2 )) || $devOption == "exit" ]]; then
        exit
    elif [[ $devOption =~ ^[+-]?[0-9]+$ ]]; then
        # check to see if the inputted number is less than or equal to projectCount to make sure it is a valid option
        if [[ $devOption -le $projectCount && $devOption -gt 0 ]]; then
            pathName=${projectPaths[$(( devOption - 1 ))]}
        fi
    fi

    # if the path was not found, print an error message
    if [[ $pathName == "null" ]]; then
        echo -e "\nInvalid selection. If you want to open a new project, please make sure that the project name and path is added to the \"set_up_dev.csv\" file."
        echo -e "This is what your \"set_up_dev.csv\" file has right now.\n"
        cat personal_automation_info/set_up_dev.csv
        echo -e "\n"
    else
        # navigate to the specified path
        cd $pathName
    fi
}

performGithubActions(){
    # set IFS variable to an empty string to avoid splitting strings in substrings
    IFS=""
    if [[ -z $1 ]]; then
        navigateToProject
    fi
    while [[ true ]]; do
        # Check if the parameter passed is null
        if [[ -z $1 ]]; then
            # provide a list of gihub actions for the user to choose from
            local githubActions=("pull" "add" "commit" "push" "switch branch" "open pull request" "merge" "go back" "exit")
            local actionCounter=1
            echo -e "\n"
            promptUser "${githubActions[@]}"
            # prompt the user for what command they want to run
            read -r -p "Which github command would you like to run: " gitCommand
        else
            local gitCommand=$1
        fi

        # based on what the user selects, execute the appropriate commands
        case $gitCommand in
            1|"pull")
                $(git pull)
                ;;
            2|"add")
                # let the user add as many files as they want
                while [[ true ]]; do
                    read -r -p "Please enter the file name that you want to add. Type \"exit\" to quit: " fileName
                    if [[ $fileName == "exit" ]]; then
                        # return with a success code
                        return 0
                    fi
                    echo "Added $fileName"
                    $(git add $fileName)
                done
                ;;
            3|"commit")
                read -r -p "Please type your commit message: " commitMessage
                read -r -p "Do you want to add files first? (y/n): " confirmAdd
                if [[ $confirmAdd == 'y' ]]; then
                    # only commit if adding files runs successfully
                    performGithubActions "add" && $(git commit -m $commitMessage)
                else
                    $(git commit -m $commitMessage)
                fi
                ;;
            4|"push")
                read -r -p "Do you want to commit files first? (y/n): " confirmCommit
                if [[ $confirmCommit == 'y' ]]; then
                    # only push if committing runs successfully
                    performGithubActions "commit" && $(git push)
                else
                    $(git push)
                fi
                ;;
            5|"switch branch")
                read -r -p "Enter the name of the branch you want to switch to: " branchName
                $(git checkout $branchName)
                ;;
            6|"open pull request")
                read -r -p "Enter the title of your pull request: " prTitle
                read -r -p "Enter the body of your pull request: " prBody
                # create a pull request using github cli with the specified title and body
                $(gh pr create --title $prTitle --body $prBody)
                ;;
            7|"merge")
                read -r -p "Enter the name of the branch you would like to merge with main: " branchName
                mergeTypes=("merge commit" "squash commit" "rebase commit" "go back" "exit")
                promptUser ${mergeTypes[@]}
                read -r -p "What type of merge would you like to perform: " mergeType
                case $mergeType in
                    1|"merge commit")
                        # merge the specified branch with main using a merge commit, delete the local and remote branch afters
                        $(gh pr merge $branchName --merge --delete-branch)
                        ;;
                    2|"squash commit")
                        # merge the specified branch with main using a squash commit, delete the local and remote branch afters
                        $(gh pr merge $branchName --squash --delete-branch)
                        ;;
                    3|"rebase commit")
                        # merge the specified branch with main using a rebase commit, delete the local and remote branch afters
                        $(gh pr merge $branchName --rebase --delete-branch)
                        ;;
                    4|"go back")
                        return
                        ;;
                    5|"exit")
                        exit
                        ;;
                    *)
                        echo "Invalid option"
                        ;;
                esac
                ;;
            8|"go back")
                return 4
                ;;
            9|"exit")
                exit
                ;;
            *)
                echo "Invalid Selection"
        esac
    done
}

# get the project directory absolute path
automationScriptsDirectory=$(< .project_path.txt)
# navigate to the project directory
cd $automationScriptsDirectory
