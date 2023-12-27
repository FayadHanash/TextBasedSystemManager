#!/bin/bash
#Text-based system manager Linux 
#Group 43 Fayad Al Hanash & Elham Salehnia


source user.bash
source group.bash
source folder.bash
source net_info.bash
source common.bash

# main function
main (){
	if [ $(id -u) -eq 0 ]; then
        main_choice=""
        while [ "$main_choice" != "ex" ]
        do	
            clear
            menu
            echo "Choice"
            read main_choice
            case $main_choice in
            ni | NI) netInfo ;;
            ua | UA) userAdd ;;
            ul | UL) userList ;;
            uv | UV) userView ;;
            um | UM) userModify ;;
            ud | UD) userDelete ;;
            ga | GA) groupAdd ;;
            gl | GL) groupList ;;
            gv | GV) groupView ;;
            gm | GM) groupModify ;;
            gd | GD) groupDelete ;;
            fa | FA) folderAdd ;;
            fl | FL) folderList ;;
            fv | FV) folderView ;;
            fm | FM) folderModify ;;
            fd | FD) folderDelete ;;
            ex | EX) echo "Exiting..."
            main_choice="ex"
            break ;;
            *) 
            print $red "Wrong input" 
            ;;

        esac
        read -rp "Press enter to continue..." input
    done
    else 
        print $yellow "You have to run the script with root or sudo"
    fi;
}



# function to print main menu
menu ()
{       
    display_title
    print_red_white "ni" "Network Info  (Network information)"
    echo ""
    print_red_white "ua" "UserAdd       (Create a new user)"
    print_red_white "ul" "User List     (List all login users)"
    print_red_white "uv" "User View     (View user properties)"
    print_red_white "um" "User Modify   (Modify user properties)"
    print_red_white "ud" "User Delete   (Delete a login user)"
    echo ""
    print_red_white "ga" "Group Add     (Create a new group)"
    print_red_white "gl" "Group List    (List all groups, not system groups)"
    print_red_white "gv" "Group View    (List all users in a group)"
    print_red_white "gm" "Group Modify  (Add/remove user to/from a group)"
    print_red_white "gd" "Group Delete  (Delete a group, not system groups)"
    echo ""
    print_red_white "fa" "Folder Add    (Create a new folder)"
    print_red_white "fl" "Folder List   (View content in a folder)"
    print_red_white "fv" "Folder View   (View folder properties)"
    print_red_white "fm" "Folder Modify (Modify folder properties)"
    print_red_white "fd" "Folder Delete (Delete a folder)"
    echo ""
    print_red_white "ex" "Exit          (Exit System Manager)"
    display_line
}


main  
