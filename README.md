# Automation Scripts

Welcome to the Automation Scripts Github repository! Automation scripts performes repetitive tasks and can setup your workflows for you. Below is a description of how to use and how to contribute to automation scripts.

## Installation Guide 

This section will talk about how to install the neccessary componenets and get the automation scripts up and running on your system.

### Bash Installation Guide

These automation scripts use the Bash shell. The curent supported Bash version is Bash 3. 

#### Mac Users

If you are on Mac, then your default shell is set to zsh. Although many features across bash and zsh are similar, you will get the best results if you [switch your default shell to bash](https://www.cyberciti.biz/faq/change-default-shell-to-bash-on-macos-catalina/).

To summarize the article above, you can run the following command in your terminal:

```chsh -s bin/bash```

After you run this command, then relaunch your terminal and your default shell should now be bash. 

#### Windows Users

If you are on Windows, we recommend that you install Windows Subsystem for Linux 2 (WSL2). This will allow you to use a Linux environment directly in Windows without needing to dual boot. 

We recommend you follow [Microsoft's documentation on how to install WSL2 for your Windows machine](https://learn.microsoft.com/en-us/windows/wsl/install). 

To summarize the article above, you can run the following command in powershell:

```wsl --install```

This will install the default Linux distribution which is Ubuntu. If you prefer to install a different distribution, then please refer to Microsoft's documentation as they explain how to do so. 

Once WSL2 is installed, you should run the automation scripts inside of WSL2 instead of Windows command prompt or powershell. 

The default shell in WSL2 should be bash. Refer to the next section for Linux Users to confirm if your default shell is bash.

#### Linux Users

Your default shell should already be bash. You can verify this by running the following command:

```echo $SHELL```

If the path printed points towards bash, then you are good to go. If not, then please change your default shell to bash by following the appropriate steps for your Linux distribution.

### Dowloading automation scripts to your device

In order to download the automation scripts, we recommend that you clone this repository onto your computer. Please refer to the [github docs on cloning a repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository?tool=webui&platform=mac) to see how to do this.

***Note:** Please make sure to change which OS you are running at the top of the file to get the most accurate instructions.*

## How to Use Automation Scripts

### Setting up files for automation scripts to run effectively

Once you have the automation scripts downloaded, you can begin using them soon, but there is still one more setup step left. The github repository does not contain the personal_automation_info directory or any of the files contained with it as these files need to be personalized for each user. Therefore, you will need to setup this directory for your use.

In the terminal, run the following command to run the setup process to create the personal_automation_info directory and the files inside of it:

```bash <path to main.sh>```

Make sure to use absolute paths for the main.sh file.

Once you run the command above, it will take care of setting up the personal_automation_info directory for you. Refer to the next section for a brief description of how to use the files within the personal_automation_info directory.

### How to use the files within the personal_automation_info directory

The following table summarizes how to use the files within the personal_automation_info directory to customize automation scripts to your work flow.

| File Name | How to Use this file | Associated With |
| :-------: | :------------------: | :-------------: |
| [set_up_apps.txt](docs/set_up_apps.md) | Put the name of the app you want to open on each new line. | set_up_apps.sh |
| [set_up_dev.csv](docs/set_up_dev.md) | In a comma seperated list, put the name of the project first, then the absolute path to the project.  Put each project on a new line. | set_up_dev.sh
| [set_up_files_and_directories.csv](docs/run_set_up_files_and_directories.md) | In a comma seperated list, put the file name first, then the absolute path to the file, then the application you want to open the file in. Put each file on a new line. | set_up_files_and_directories.sh |
| [set_up_web.csv](docs/set_up_web.md) | In a comma seperated list, put the name of the webpage, then the url of the webpage you want to open, the the browswer you want to open the url in. Put each url on a new line. | set_up_web.sh |
| [time_manger.csv](docs/time_manager.md) | In a comma seperated list, put the name of the workflow step, then put a list of commands seperated by spaces that you want to run, then put the time in minutes that you want to spend on the workflow step. Put each workflow step on a new line. | time_manager.sh |

Please click on the links and read the documentation to get a better understanding of the expected format for all the files within the personal_automation_info directory.