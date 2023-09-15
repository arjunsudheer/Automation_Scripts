# set_up_web.sh Documentation

## Overview
The set_up_web.sh file will open the specified web page url in the specified browser on your computer.

**Required File Parameters:** None

***

## openWebPage() function
**Optional parameter:** None

* Read the webpage name, url, and browser with which to open the url from the set_up_web.csv file

* Provide a list of urls for the user to open

* Check the user's operating system and run the appropriate command to open a url

# The set_up_web.csv file
The set_up_web.csv file contains the urls that the user wants to option to open. Please enter the information for each url name on a new line. It is expected that you enter webpage names, urls, and the browsers to open the urls with into set_up_dev.csv in the following format.

```
webpage_name,url,browser_to_open_url
```

Please **DO NOT** leave any blank lines in your file in order to follow the expected format.