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

#### Windows Users

If you are on Windows, we recommend that you install Windows Subsystem for Linux 2 (WSL 2). This will allow you to use a Linux environment directly in Windows without needing to dual boot.

We recommend you follow [Microsoft's documentation on how to install WSL2 for your Windows machine](https://learn.microsoft.com/en-us/windows/wsl/install). 

To summarize the article above, you can run the following command in powershell:

```
wsl --install
```

This will install the default Linux distribution which is Ubuntu. If you prefer to install a different distribution, then please refer to Microsoft's documentation as they explain how to do so. 

Once WSL2 is installed, you should run the automation scripts inside of WSL2 instead of Windows Command Prompt or Powershell. 

The default shell in WSL 2 should be bash. Refer to the next section for Linux Users to confirm if your default shell is bash.

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

### Windows (WSL 2) and Linux Users

To add an alias to Automation Scripts on a Windows machine running WSL 2 or a Linux machine, run the following command in your terminal:

```
echo 'alias atms="<path to automation_scripts.sh>"' >> ~/.bashrc
```

Make sure that you replace ```<path to automation_scripts.sh>``` with the absolute path to the automation_scripts.sh file on your computer.

After running the command above, restart your terminal. You should now be able to type ```atms``` in your terminal to quickly run Automation Scripts. Try running ```atms -h``` for a quick guide on how to use Automation Scripts.