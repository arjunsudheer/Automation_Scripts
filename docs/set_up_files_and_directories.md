## Overview
The set_up_files_and_directories.sh file will open the specified file or directory on your computer.

**Required File Parameters:** None

***

## openFiles() function
**Optional parameter:** None

* Read the file and directory options from the set_up_files.csv file

* Provide a list of files and directories for the user to open

* Check the user's operating system and run the appropriate command to open the file or directory in the specified application

# The set_up_files.csv file
The set_up_files.csv file contains the names and paths of files and directores that the user wants to open, along with the specified application to open each file or directory in. Please enter the information for each file or directory on a new line.

The set_up_files.csv file is used to keep track of your files and directories and their paths. It is expected that you enter the names of your files and directories, their absolute paths, and the application to open them in the following format.

```filename_or_directory,path_to_file_or_directory,application_to_open_file_or_directory```

Please **DO NOT** leave any blank lines in your file in order to follow the expected format. Also, please make sure that your path names are absolute paths and not relative paths. This ensures that we can access your file regardless of our location in your computer's file system.