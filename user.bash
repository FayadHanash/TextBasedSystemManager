#!/bin/bash

source common.bash 

# function to add a user
userAdd () 
{
    display_title
    read -rp "Enter a user name: " uName
    adduser $uName
    validate "The user $uName has been added" "Couldn\'t create the user $uName"
    display_line
}

# function to list all users
userList () 
{
    display_title
    print $blue "Processing..."
    users=$(getent passwd {1000..60000} | cut -d: -f1)
    uCount=$(echo $users | wc -w )
    print $green "There are $uCount users:"
    echo "$users" | nl 
    display_line
}

# function to view user properties
userView () 
{
    display_title
    read -rp "Which user would you like to view: " uTView
    saveUTV=$(echo "$uTView":)
    uTSearch=$(getent passwd | grep ^"$saveUTV")
    if [ $? -eq 0 ]; then
        echo "properties for user: $uTView "
        echo ""
        print_red_white "User:     " "`echo "$uTSearch" | cut -d: -f1`"
        print_red_white "Password: " "`echo "$uTSearch" | cut -d: -f2`"
        print_red_white "User ID:  " "`echo "$uTSearch" | cut -d: -f3`"
        print_red_white "Group ID: " "`echo "$uTSearch" | cut -d: -f4`"
        print_red_white "Comment:  " "`echo "$uTSearch" | cut -d: -f5 | sed 's/,/ /g'`"
        print_red_white "Directory:" "`echo "$uTSearch" | cut -d: -f6`"
        print_red_white "Shell:    " "`echo "$uTSearch" | cut -d: -f7`"
        echo ""
        print_red_white "Groups:   " "`id -nG "$uTView"`"
    else
        print $yellow "There is no user for this name"
    fi;
    display_line
}

# function to print user modify menu
userModifyMenu ()
{
    display_title
    echo -e "****************************USERS MANAGEMENT************************"
    echo ""
    print_red_white "un" "UserName         (Change user name)"
    print_red_white "pw" "password         (Change password)"
    print_red_white "ui" "User ID          (Change ID)"
    print_red_white "ug" "Group ID         (Change group ID)"
    print_red_white "uc" "Comment          (Add a new comment)"
    print_red_white "uf" "User directory   (Change user home directory)"
    print_red_white "us" "User shell       (Change user shell)"
    print_red_white "ex" "Exit             (Go back to main list)"
    display_line
}


# function to modify user properties
userModify () 
{
    display_title

    read -rp "Which user would you like to modify (enter ex to exit): " uModify
    if [ "$uModify" = "ex" ];then
        return 1;
    fi;

    getent passwd | grep ^"$uModify" &> /dev/null
    if [ $? -eq 0 ];then
        user_choice=""
        while [ "$user_choice" != "ex" ]
        do
        userModifyMenu
        print $yellow "You are modifying the user: $uModify"
        display_line
        read -rp "Choice: " user_choice
        case "$user_choice" in
            un | UN)
                read -rp "Enter a new name: " newName
                error=$(usermod -l "$newName" "$uModify" 2>&1)
                validate "The name has been modified" "Couldn\'t modify user name" "`echo $error | cut -d: -f2 `"
                ;;
            pw | PW)
                #	echo "Enter a new password"
                #	read newPW
                passwd "$uModify"
                validate "The password has been modified" "Couldn\'t modify user password"
                ;;
            ui | UI)
                read -rp "Enter a new user ID: " newUid
                error=$(usermod -u "$newUid" "$uModify" 2>&1 )
                validate "The user ID has been modified" "Couldn\'t modify user ID" "`echo $error | cut -d: -f2 `"
                ;;
            ug | UG)
                read -rp "Enter a new group ID: " newGid
                error=$(usermod -g "$newGid" "$uModify" 2>&1)
                validate "The group ID has been modified" "Couldn\'t modify group ID" "`echo $error | cut -d: -f2 `"
                ;;
            uc | UC)
                read -rp "Enter a new comment: " newC
                error=$(usermod -c "$newC" "$uModify" 2>&1)
                validate "The comment has been modified" "Couldn\'t modify comment" "`echo $error | cut -d: -f2 `"
                ;;
            uf |UF)
                read -rp "Enter a new home directory: " newHD
                mkdir /home/"$newHD" 2> /dev/null
                error=$(usermod -d /home/"$newHD" "$uModify" 2>&1)
                validate "The home directory has been modified" "Couldn\'t modify home directory" "`echo $error | cut -d: -f2 `"
                ;;
            us | US)
                read -rp "Enter a new shell: " newSH
                error=$(usermod -s /bin/"$newSH" "$uModify" 2>&1)
                validate "The shell has been modified" "Couldn\'t modify user shell" "`echo $error | cut -d: -f2 `"
                ;;
            ex | EX)
                echo "returning to main menu"
                user_choice="ex"
                break ;;
            *)
                print $red "Wrong choice"
                ;;
        esac
        read -rp "Press enter to continue..." input
        done
    else
        print $yellow "Could not access user $uModify"
    fi;
    
    display_line
}

# function to delete a user
userDelete () 
{	
    display_title
    read -rp "Which user would you like to delete: " uTDelete
    read -rp "Are you sure you want to delete the user $uTDelete (y/n): " answer
    if [ "$answer" = "y" ]; then
        error=$(userdel -r "$uTDelete" 2>/dev/null)
        validate "The user $uTDelete has been removed" "Couldn\'t remove user $uTDelete" "`echo $error | cut -d: -f2 `"
    else
        print $yellow "The user $uTDelete has not been removed"
    fi;
    display_line
}

