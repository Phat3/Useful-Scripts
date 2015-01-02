#!/bin/bash

#tool that provides common enumeration when you try a privilege escalation on linux

#OS info enumeration

#function that show the title of the section
#
#$1 =title of the section (es: system Info)
echo_title(){
   echo -e "\e[00;33m### $1 ##############################################\e[00m"
    echo -e "\n"
}


#function that show the given command in a proper format
#
#$1 = short description of the command
#$2 = comand itself
echo_command(){
    echo -e "\e[1;33m$1: \n\e[\033[1;0m"
    $2
    echo -e "\n"
}

#function that cicle for each command in the given array and execute the commands
#
#$1 = array of title => commands
run_section_commands(){
    #create a new array from the arguent
    eval "declare -A arg_array="${1#*=}
    #execute comand
    for key in "${!arg_array[@]}"; do
       echo_command $key "${arg_array[$key]}"
    done
}

#enumerate the system info
declare -A SYSTEM_INFO=(
    ["ALL"]="uname -a"
    ["KERNEL_RELEASE"]="uname -r"
    ["HOSTNAME"]="hostname"
    ["ARCH"]="uname -m"
    ["KERNEL_INFO"]="cat /proc/version"
    ["DISTRO_INFO"]="cat /etc/issue"
)

#enumerate the info about usera and groups on the system
declare -A USER_GROUP=(
    ["ALL_USERS"]="cat /etc/passwd"
    ["ALL_GROUPS"]="cat /etc/group"
    ["SUDOERS"]="grep -E ":0:" /etc/passwd"
    ["USER_CURRENT_LOGGED"]="w"
)

#enumerate the info about usera and groups on the system
declare -A CURRENT_USER=(
    ["WHOAMI"]="whoami"
    ["ID"]="id"
)


echo -e "\n\e[00;31m#########################################################\e[00m"
echo -e "\e[00;31m#\e[00m" "\e[00;33m             Privilege Escalation Script             \e[00m" "\e[00;31m#\e[00m"
echo -e "\e[00;31m#########################################################\e[00m"

echo -e "\n"

#enumerate the OS kernel version, the distro ecc...

echo_title "SYSTEM INFO"

run_section_commands "$(declare -p SYSTEM_INFO)"

#enumerate the users and groups on the system and what they are doing

echo_title "USERS AND GROUPS INFO"

run_section_commands "$(declare -p USER_GROUP)"

#enumerate the curent user info

echo_title "CURRENT USER INFO"

run_section_commands "$(declare -p CURRENT_USER)"

