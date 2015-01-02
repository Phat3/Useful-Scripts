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
    eval $2
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

#enumerate system info
declare -A SYSTEM_INFO=(
    ["ALL"]="uname -a"
    ["KERNEL_RELEASE"]="uname -r"
    ["HOSTNAME"]="hostname"
    ["ARCH"]="uname -m"
    ["KERNEL_INFO"]="cat /proc/version"
    ["DISTRO_INFO"]="cat /etc/issue"
)

#enumerate infos about users and groups on the system
declare -A USER_GROUP=(
    ["ALL_USERS"]="cat /etc/passwd"
    ["ALL_GROUPS"]="cat /etc/group"
    ["SUDOERS"]="grep -E ":0:" /etc/passwd"
    ["USER_CURRENT_LOGGED"]="w"
)

#enumerate infos about current user
declare -A CURRENT_USER=(
    ["WHOAMI"]="whoami"
    ["ID"]="id"
)

#enumerate environment info
declare -A ENV_INFO=(
    ["VARIABLES"]="env"
    ["HISTORY"]="history"
)

#enumerate interesting files on the system
declare -A INTERESTING_FILES_DISCOVER=(
    ["SUID_FILES"]="find / -perm -4000 -type f 2>/dev/null"
    ["WORLD_WRITABLE_FILES"]="find / ! -path "*/proc/*" -perm -2 -type f"
    ["WORLD_WRITABLE_DIR"]="find / -perm -2 -type d"
    ["ROOT_DIR_ACCESS"]="ls -ahlR /root/"
    ["BASH_HISTORY"]="cat ~/.bash_history"
    ["SSH_FILES"]="ls -la ~/.ssh/"
    ["LOG_FILE_WITH_PASS"]="grep -l -i pass /var/log/*.log 2>/dev/null"
    ["LIST_OPEN_FILES"]="lsof -i -n"
)

#enumerate the processes
declare -A SERVICE_INFO=(
    ["ROOT_PROCESS"]="ps -aux | grep root"
    ["IINETD_PROCESS"]="cat /etc/inetd.conf"
    ["XINETD_PROCESS"]="cat /etc/xinetd.conf"
)

#enumerate cron jobs
declare -A JOBS_INFO=(
    ["CRON"]="ls -la /etc/cron*"
    ["CRON_WRITABLE"]=" ls -aRl /etc/cron* | grep -E "w.  " "
)

#enumerate network info
declare -A  NETWORK_INFO=(
    ["INTERFACES"]="/sbin/ifconfig -a"
    ["ROUTES"]="route"
    ["DNS"]="cat /etc/resolv.conf"
    ["TCP_CONNECTION"]="netstat -ant"
    ["UDP_CONNECTION"]="netstat -anu"
    ["USED_PORT"]="cat /etc/services"
)


#enumerate programs info
declare -A  PROGRAMS_INFO=(
    ["SUDO_VERSION"]="sudo -V | head -1"
    ["PROGRAMS_DEBIAN"]="dpkg -l"
    ["PROGRAMS_REDHAT"]="rpm -qa"
    ["COMPILERS_DECOMPILERS"]="dpkg --list 2>/dev/null| grep compiler |grep -v decompiler 2>/dev/null && yum list installed 'gcc*' 2>/dev/null| grep gcc 2>/dev/null"
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

#enumerate the unvironment info

echo_title "ENV INFO"

run_section_commands "$(declare -p ENV_INFO)"

#enumerate the interesting files on the system

echo_title "INTERESTING FILES"

run_section_commands "$(declare -p INTERESTING_FILES_DISCOVER)"

#enumerate the processes

echo_title "SERVICE INFO"

run_section_commands "$(declare -p SERVICE_INFO)"

#enumerate cron jobs

echo_title "CRON INFO"

run_section_commands "$(declare -p JOBS_INFO)"

#enumerate cron jobs

echo_title "NETWORK INFO"

run_section_commands "$(declare -p NETWORK_INFO)"

#enumerate cron jobs

echo_title "PROGRAMS INFO"

run_section_commands "$(declare -p PROGRAMS_INFO)"


