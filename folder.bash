#!/bin/bash

source common.bash


# function to add a folder
folderAdd () 
{
    display_title
    read -rp "Enter folder name: " fName
    error=$(mkdir "$fName" 2>&1)
    validate "The folder $fName has been created" "Couldn\'t create the folder $fName" "`echo  $error | cut -d: -f2-3 |sed 's/:/ /g' | sed 's/directory/folder/g' `"
    display_line
}

# function to list all folders
folderList () 
{
    display_title
    print $green "Your current location: `pwd`"
    echo "Enter the folder name (You have to enter relative/absolute paths in some cases): "
    read fList
    error=$(ls --color "$fList" 2>&1)
    if [ $? -eq 0 ]; then
        print $green "The folder $fList contains:"
        echo "$error" | nl
    else	
        print $yellow "`echo $error | cut -d: -f2,3 | sed 's/directory/folder/g'`"
    fi;
    display_line
}

# function to view folder properties
folderView () 
{
    display_title
    print $green "Your current location: `pwd`"
    echo "Enter the folder name (you have to enter relative/absolute paths in some cases): "
    read fView
    error=$(ls "$fView" 2>&1)
    if [ $? -eq 0 ]; then
        property=$(ls -ld "$fView")
        fSize=$(ls -ld -lh "$fView")
        permission=$(echo $property |head -c 10 | tail -c 9)
        time=$(date +%y%m%d%t%H:%M:%S -r "$fView")
        print $green "*************************** folder properties ***************************"
        print_red_white "Name:                        " "$fView"
        print_red_white "User Owner:                  " "`echo $property | cut -d' ' -f3`"
        print_red_white "Group Owner:                 " "`echo $property | cut -d' ' -f4`"
        print_red_white "File Size:                   " "`echo $fSize | cut -d' ' -f5`"
        print_red_white "Timestamp(last modified):    " "`echo $time`"
        print $green "*************************** permissons ***************************"
        print_red_white "User permissions: User can   " "`echo $permission | head -c 3 | sed 's/r/ read /g; s/w/ write /g; s/x/ execute /g;'`"
        print_red_white "Group permissions: Group can " "`echo $permission | head -c 6 | tail -c 3 | sed ' s/r/ read /g; s/w/ write /g; s/x/ execute /g; s/s/ execute (setgid is on)/g; s/S/ (setgid is on)/g;'`"
        print_red_white "Others permissions: Other can" "`echo $permission | tail -c 4 | sed ' s/r/read/g; s/t/sticky bit is on/g; s/w/ write /g; s/x/execute/g; s/T/sticky bit is on/g;'`"

    else	
        print $yellow "`echo $error | cut -d: -f2,3 | sed 's/directory/folder/g'`"
    fi;
    display_line
}

# function to print folder modify menu
folderModifyMenu() 
{
    display_title
    print $green "****************************FOLDER MANAGEMENT***********************"
    print_red_white "uo" "User Ownership         (Change user ownership)"
    print_red_white "up" "User Permission         (Change user permission)"
    print_red_white "go" "Group Ownership        (Change group ownership)"
    print_red_white "gp" "Group Permission       (Change group permission)"
    print_red_white "op" "Others Permission      (Change others permisson)"
    print_red_white "st" "Sticky bit             (set/unset sticky bit)"
    print_red_white "sg" "Setgid                 (set /unset setgid)"
    print_red_white "lm" "last modified          (last modified)"
    print_red_white "ex" "Exit                   (Go back to main list)"
    display_line
}

# function to modify folder properties
folderModify () 
{
    display_title
    print $green "Your current location: `pwd`"
    read -rp "Which folder whould you like to modify: " fTModify
    error=$(ls "$fTModify" 2>&1 )
    if [ $? -eq 0 ];then
        folder_choice=""
        while [ "$folder_choice" != "ex" ]
        do
        clear
        folderModifyMenu
        print $green "Your current location: `pwd`"
        print $yellow "You are modifying the folder: $fTModify"
        display_line
        read -rp "Choice: " folder_choice
        case "$folder_choice" in
            uo | UO)
                read -rp "Enter a new user owner: " nUOwner
                error=$(chown "$nUOwner" "$fTModify" 2>&1)
                validate "The user ownership has been changed" "Couldn\'t change user ownership" "`echo $error`"
            ;;
            go | GO)
                read -rp "Enter a new group owner: " nGOwner
                error=$(chgrp "$nGOwner" "$fTModify" 2>&1)
                validate "The group ownership has been changed" "Couldn\'t change group ownership" "`echo $error`"
            ;;
            up | UP)
                modify_permission "the owner to read file" "u" "r" "$fTModify"
                modify_permission "the owner to write on file" "u" "w" "$fTModify"
                modify_permission "the owner to execute file" "u" "x" "$fTModify"
            ;;
            gp | GP)
                modify_permission "the group to read file" "g" "r" "$fTModify"
                modify_permission "the group to write file" "g" "w" "$fTModify"
                modify_permission "the group to execute file" "g" "x" "$fTModify"
            ;;
            op | OP)
                modify_permission "the others to read file" "o" "r" "$fTModify"
                modify_permission "the others to write file" "o" "w" "$fTModify"
                modify_permission "the others to execute file" "o" "x" "$fTModify" 
            ;;
            st | ST)
                get_input "Would you like to set sticky bit (y/n): "
                if [ $? -eq 0 ];then
                    error=$(chmod +t "$fTModify" 2>&1)
                    validate "The sticky bit has been set" "Couldn\'t set sticky bit" "`echo $error`"
                else
                    error=$(chmod -t "$fTModify" 2>&1)
                    validate "The sticky bit has been unset" "Couldn\'t unset sticky bit" "`echo $error`"
                fi;
            ;;
            sg | SG)
                get_input "Would you like to set setgid (y/n): "
                if [ $? -eq 0 ];then
                    error=$(chmod +s "$fTModify" 2>&1)
                    validate "The setgid has been set" "Couldn\'t set setgid" "`echo $error`"
                else
                    error=$(chmod -s "$fTModify" 2>&1)
                    validate "The setgid has been unset" "Couldn\'t unset setgid" "`echo $error`"
                fi;
            ;;
            lm | LM)
                read -rp "Which folder would you like to see last modified: " fTSLTime
                time=$(date +%y%m%d%t%H:%M:%S -r "$fTSLTime")
                print_red_white "Timestamp(last modified): " "`echo $time`$Non"
                ;;
            ex | EX)
                echo "returning to main menu"
                folder_choice="ex"
                break
                ;;
            *)
                print $red "Wrong input"
                ;;
            esac
            read -rp "Press enter to continue..." input
            done	
    else
        print $yellow "The folder $fTModify could not access"
    fi;
    display_line
}

# function to delete a folder
folderDelete () 
{
    display_title
    read -rp "Which folder would you like to delete: " fDelete
    read -rp "Are you sure you want to delete the folder $fDelete (y/n): " answer
    if [ "$answer" = "y" ]; then
        error=$(rm -r "$fDelete" 2>&1)
        validate "The folder $fDelete has been removed" "Couldn\'t remove the folder $fDelete" "`echo $error | cut -d: -f2-3 | sed 's/directory/folder/g'`"
    else
        print $yellow "The folder $fDelete has not been removed"
    fi;
    display_line
}


# function to modify permissions
modify_permission() 
{
    print $green "Would you like to allow $1 (y/n): "
    read answer   
    permission=""
    status=""         
    if [ "$answer" = "y" ]; then
        permission="$2+$3"
        status="The permission has been allowed"
    else
        permission="$2-$3"
        status="The permission has not been allowed"
    fi;
    error=$(chmod $permission "$4" 2>&1)
    validate "$status" "Couldn\'t change ownership" "`echo $error`"
}