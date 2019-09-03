#! /bin/sh

#-----COLOR--------
RED='\033[1;31m'
GREEN='\033[1;32m'
BLUE='\033[1;36m'
DEFAULT='\033[00m'


#------ FIRST ERROR HANDLING -------

if [ "$(id -u)" == "0" ]; then
    echo -e $RED "====== Don't run this as root =======" $DEFAULT
    exit 84
fi

if [ $# -ne 0 ]; then
    echo -e $RED "===== No argument required =====" $DEFAULT
    exit 84
fi

#--------ENV-------

OS=(`uname`)
if [ $OS = "Linux" ]; then
    echo -e $BLUE "You are using a $OS !\n\tWELCOME\n" $DEFAULT
else
    echo -e $RED "Only Linux is supported\n" $DEFAULT
    exit 84
fi

declare -A osInfo;
osInfo[/etc/redhat-release]=yum
osInfo[/etc/arch-release]=pacman


for f in ${!osInfo[@]}
do
    if [[ -f $f ]];then
        echo -e $BLUE Package manager: ${osInfo[$f]} $DEFAULT
        PCKG_MANAGER=${osInfo[$f]}
    fi
done

if [ $PCKG_MANAGER = "pacman" ]; then
    PCKG_UPDATE='sudo pacman --noconfirm -Syyu'
    PCKG_INSTALL='sudo pacman --noconfirm -S'
elif [ $PCKG_MANAGER = "apt-get" ]; then
    PCKG_UPDATE='sudo apt-get -y update; sudo apt-get -y upgrade'
    PCKG_INSTALL='sudo apt-get install'
else
    echo -e $RED "Package manager not supported\n" $DEFAULT
    exit 84
fi

#------- USEFUL FUNCTIONS ------

function error_handling
{
    res=$1
    if [ $res -eq 0 ]; then
        return
    else
        echo -e $RED "[AN ERROR OCCURRED]" $DEFAULT "stop installation ? [Y/n]"
        read stop
        case $stop in
            n|N) return;;
            *) exit 84;;
        esac
    fi
}

#------ INSTALL -------
$PCKG_UPDATE
$PCKG_INSTALL nano
error_handling $?
$PCKG_INSTALL emacs
error_handling $?
$PCKG_INSTALL code
error_handling $?

echo -e $GREEN "\n======= Successfully installed editors ======\n" $DEFAULT

