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
    echo -e "\e[1;33m$1: \e[\033[1;0m" $($2)
    echo -e "\n"
}

run_section_commands(){
    declare -A argAry1=("${!1}")
    for K in "${!argAry1[@]}"; do
        echo $K --- ${argAry1[$K]};
    done
}

declare -A SYSTEM_INFO=(
    ["ALL"]="umane -a"
    ["KERNEL_RELEASE"]="uname -r"
    ["HOSTNAME"]="hostname"
    ["ARCH"]="uname -m"
    )

echo -e "\n\e[00;31m#########################################################\e[00m"
echo -e "\e[00;31m#\e[00m" "\e[00;33m             Privilege Escalation Script             \e[00m" "\e[00;31m#\e[00m"
echo -e "\e[00;31m#########################################################\e[00m"

echo -e "\n"

#enumerate the OS kernel version, the distro ecc...

echo_title "SYSTEM INFO"

run_section_commands SYSTEM_INFO[@]
