#!/bin/bash

# will prompt the user with the option from the array provided
# expects an array of prompts to present to the user
promptUser() {
    if ! [[ -z "$1" ]]; then
        local userOptions=("$@")
        echo -e "\n"
        local optionCount=1
        for i in "${userOptions[@]}"; do
            echo "$optionCount) $i"
            (( optionCount++ ))
        done
    fi
}
