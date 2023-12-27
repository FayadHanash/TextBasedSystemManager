#!/bin/bash

source common.bash


# function to add a group
groupAdd () 
{
    display_title
    read -rp "Enter a group name: " gName
    error=$(groupadd "$gName" 2>&1)
    validate "The group $gName has been created" "Couldn\'t create the group $gName" "`echo $error | cut -d: -f2 `"
    display_line
}

# function to list all groups
groupList () 
{
    display_title
    print $blue "Processing..."
    groups=$(getent group {1000..60000} | cut -d: -f1)
    gCount=$(echo $groups | wc -w )
    print $green "There are $gCount groups:"
    echo "$groups" | nl 
    display_line
}

# function to view group properties
groupView () 
{
    display_title
    read -rp "Which group would you like to view: " gTView
    getent group | grep ^"$gTView:" > /dev/null
    if [ $? -eq 0 ]; then
        echo "Members in the group($gTView):"
        members=$(getent group | grep ^"$gTView:" | cut -d: -f4)
        membersCount=$(echo "$members" | wc -w) 
        if [ $membersCount -gt 0 ]; then      #member?
            echo "$members" | sed 's/,/\n/g' | nl
        else
            print $yellow "There is no member in the group"
        fi;
    else
        print $yellow "There is no group for this name"
    fi;
    display_line
}


# function to print group modify menu
groupModifyMenu ()
{
    display_title
    echo -e "****************************GROUPS MANAGEMENT***********************"
    print_red_white "au" "Add User        (Add users to a group)"
    print_red_white "rm" "Remove User     (Remove users from a group)"
    print_red_white "ex" "Exit            (Go back to main menu)"
    display_line
}

# function to modify group properties
groupModify () 
{
    display_title
    read -rp "Which group would you like to modify: " gTModify 
    getent group | grep ^"$gTModify:" > /dev/null
    if [ $? -eq 0 ]; then
        group_choice=""
        while [ "$group_choice" != "ex" ]
        do
        groupModifyMenu
        print $yellow "You are modifying the group: $gTModify"
        display_line
        read -rp "Choice: " group_choice
        case "$group_choice" in
            au | AU)
                read -rp "Enter a user name: " uNTAdd
                if [ $(getent passwd | grep ^"$uNTAdd": | wc -l) -eq 0 ]; then
                    print $yellow "There is no user for this name"
                else
                    error=$(usermod -aG "$gTModify" "$uNTAdd" 2>&1)
                    validate "The user $uNTAdd has been added to the group $gTModify" "Couldn\'t adding user $uNTAdd to the group $gTModify" "`echo $error | cut -d: -f2 `"
                fi;
                ;;

            rm | RM)
                read -rp "Enter a user name: " uNTDelete
                if [ $(getent passwd | grep ^"$uNTDelete": | wc -l) -eq 0 ]; then
                    print $yellow "There is no user for this name"
                else
                    error=$(gpasswd -d "$uNTDelete" "$gTModify" 2>&1)
                    validate "The user $uNTDelete has been removed from the group $gTModify" "Couldn\'t removing user $uNTDelete from the group $gTModify" "`echo $error | cut -d: -f2 `"
                fi;
                ;;
            ex | EX)
                echo "Returning to main menu..."
                group_choice="ex"
                break
                 ;;
                *) 
                print $red "Wrong input"
                ;;
        esac 
        read -rp "Press enter to continue..." input
        done

    else
        print $yellow "The group $gTModify could not access"
    fi;
    display_line
}

# function to delete a group
groupDelete () 
{
    display_title
    read -rp "Which group would you like to delete: " gDelete
    read -rp "Are you sure you want to delete the group $gDelete (y/n): " answer
    if [ "$answer" = "y" ]; then
        error=$(groupdel "$gDelete" 2>&1)
        validate "The group $gDelete has been removed" "Couldn\'t remove the group $gDelete" "`echo $error | cut -d: -f2 `"
    else
        print $yellow "The group $gDelete has not been removed"
    fi;
    display_line
}