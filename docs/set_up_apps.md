# set_up_apps.sh Documentation

## Overview
The set_up_apps.sh file will open the specified app on your computer.

**Required File Parameters:** This file takes a required parameter that specifies the path to the project folder.

***

## openApp() function
**Optional parameter:** None

* Read the app options from the set_up_apps.txt file

* Provide a list of apps for the user to open

* Check the user's operating system and run the appropriate command to open an app


# The set_up_apps.txt file
The set_up_apps.txt file contains the apps that the user wants to option to open. Please enter each app name on a new line. It is expected that you enter app names into set_up_apps.txt in the following format.

```
app_1
app_2
app_3
app_N
```

Please **DO NOT** leave any blank lines in your file in order to follow the expected format.