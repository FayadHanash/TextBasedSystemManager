#!/bin/bash

# colors
red='\033[0;31m'
blue='\033[0;34m' 
white='\033[0;37m'
green='\033[0;32m'
yellow='\033[0;93m'
Non='\033[0m'

# function to print text in color
print() 
{
    local color=$1
    local message=$2
    echo -e "$color$message$Non"
}

# function to print text in red and white colors
print_red_white()
{
    echo -e ""$red"$1$white  $2"
}

# function to print line
display_line() 
{
    echo -e ""$green"--------------------------------------------------------------------""$Non" 
}

# function to print title
display_title()
{
    clear
    echo -e ""$green"--------------------------------------------------------------------""$Non"
    echo -e ""$green"                            SYSTEM MANAGER                          ""$Non"
    echo -e ""$green"--------------------------------------------------------------------""$Non"
    echo ""
}

# function to get input from user
get_input() 
{
    echo -e "$1"
    read answer            
    if [ "$answer" = "y" ]; then
        return 0
    else
        return 1
    fi;
}

# function to validate commands and print messages in case of success or failure 
validate()
{
    local success=$1
    local fail=$2
    local error=$3
    if [ $? -eq 0 ]; then
        echo -e ""$yellow"$success"$Non""
    else 
        echo -en ""$yellow"$fail "$Non""
        echo -e ""$yellow"$error"$Non""
    fi;
}