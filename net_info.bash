#!/bin/bash

source common.bash

# function to print network information
netInfo () {
    display_title
    echo "Network Information"
    echo ""
    print_red_white "Computer name" "`lsb_release -a | head -2 | tail -1 | cut -c 14-20`"
    echo ""
    print_red_white "Interface:     " "`ip addr | head -7 | tail -1 | cut -c 3-9`" 
    print_red_white "IP address:    " "`ip addr | head -3 | tail -1 | cut -c 9-21`"
    print_red_white "Gateway:       " "`ip route | head -1 | cut -c 12-20`" 
    print_red_white "MAC:           " "`ip addr | head -8 | tail -1 | cut -c 15-33`"
    print_red_white "Status:        " "`ip addr | head -7| tail -1 | cut -c 75-77`"
    display_line
}