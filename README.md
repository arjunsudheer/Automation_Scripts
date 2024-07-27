# Automation Scripts

Automation Scripts performs repetitive tasks and can setup your workflows for you. Automation Scripts are written in Bash.

## Installation Guide 

This section will talk about how to install the necessary components and get the automation scripts up and running on your system.

### Bash Installation Guide

These automation scripts use the Bash shell. Automation Scripts will work on computers with Bash version 3 or higher.

#### Mac Users

If you are on Mac, then your default shell is set to zsh. Although many features across bash and zsh are similar, you will get the best results if you switch your default shell to bash. You can do so by running the following command in your terminal:

```
chsh -s bin/bash
```

After you run this command, make sure to relaunch your terminal.

#### Linux Users

Your default shell should already be bash. You can verify this by running the following command:

```
echo $SHELL
```

If the path printed points towards bash, then you are good to go. If not, then please change your default shell to bash by following the appropriate steps for your Linux distribution.

### Dowloading automation scripts to your device

You can clone this repository by running the following command in your terminal:

```
git clone https://github.com/arjunsudheer/automation-scripts.git
```

## Creating an alias for automation scripts

Adding an alias to Automation Scripts allows you to run Automation Scripts quickly in the terminal. The following guide will show you how to set up an alias to Automation Scripts on your computer.

### Mac Users

To add an alias to Automation Scripts on a Mac, run the following command in your terminal:

```
echo 'alias atms="<path to automation_scripts.sh>"' >> ~/.bash_profile
```

Make sure that you replace ```<path to automation_scripts.sh>``` with the absolute path to the automation_scripts.sh file on your computer.

After running the command above, restart your terminal. You should now be able to type ```atms``` in your terminal to quickly run Automation Scripts. Try running ```atms -h``` for a quick guide on how to use Automation Scripts.

### Linux Users

To add an alias to Automation Scripts on a Linux machine, run the following command in your terminal:

```
echo 'alias atms="<path to automation_scripts.sh>"' >> ~/.bashrc
```

Make sure that you replace ```<path to automation_scripts.sh>``` with the absolute path to the automation_scripts.sh file on your computer.

After running the command above, restart your terminal. You should now be able to type ```atms``` in your terminal to quickly run Automation Scripts. Try running ```atms -h``` for a quick guide on how to use Automation Scripts.