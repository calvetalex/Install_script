#! /bin/bash

cd ~

#-----COLOR--------
RED='\033[1;31m'
YELLOW='\033[1;93m'
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
    PCKG_INSTALL='sudo pacman --noconfirm -Sy'
elif [ $PCKG_MANAGER = "apt" ]; then
    PCKG_UPDATE='sudo apt -y update; sudo apt-get -y upgrade'
    PCKG_INSTALL='sudo apt install'
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
        echo -en $RED "[AN ERROR OCCURRED]" $DEFAULT "stop installation ? [Y/n]"
        read stop
        case $stop in
            n|N) return;;
            *) exit 84;;
        esac
    fi
}

function change_shell
{
    echo -n "Would you like to change to zsh ? [Y/n]"
    read choice
    case $choice in
        n|N) return;;
        *) chsh $USER -s /usr/bin/zsh
    esac
}

#------ INSTALL -------
echo -e $BLUE "---------------------------\n  UPDATING SYSTEM\n----------------------------" $DEFAULT
$PCKG_UPDATE
error_handling $?
echo -e $GREEN "\n======  Successfully update  ======\n" $DEFAULT

echo -e $BLUE '---------------------------\n  INSTALLING CURL AND WGET\n---------------------------' $DEFAULT
$PCKG_INSTALL curl
error_handling $?
$PCKG_INSTALL wget
error_handling $?
echo -e $GREEN "\n======  Successfully installed curl and wget ======\n" $DEFAULT

echo -e $BLUE '---------------------------\n  INSTALLING python\n---------------------------' $DEFAULT
$PCKG_INSTALL python3
error_handling $?
echo -e $GREEN "\n======  Successfully installed python  ======\n" $DEFAULT

echo -e $BLUE '---------------------------\n  INSTALLING GIT\n---------------------------' $DEFAULT
$PCKG_INSTALL git
error_handling $?
echo -e $GREEN "\n======  Successfully installed git  ======\n" $DEFAULT

echo -e $BLUE "---------------------------\n  INSTALLING EDITORS\n----------------------------" $DEFAULT
echo -e $YELLOW "\n======  NANO  ======\n" $DEFAULT 
$PCKG_INSTALL nano
error_handling $?
echo -e $YELLOW "\n======  VIM  ======\n" $DEFAULT 
$PCKG_INSTALL vim
error_handling $?
echo -e $YELLOW "\n======  EMACS  ======\n" $DEFAULT 
$PCKG_INSTALL emacs
error_handling $?
echo -e $YELLOW "\n======  CODE  ======\n" $DEFAULT 
$PCKG_INSTALL code
error_handling $?
echo -e $GREEN "\n======  Successfully installed editors  ======\n" $DEFAULT

echo -e $BLUE '---------------------------\n  INSTALLING TERM\n---------------------------' $DEFAULT
echo -e $YELLOW "\n======  ZSH  ======\n" $DEFAULT 
$PCKG_INSTALL zsh
error_handling $?
echo -e $YELLOW "\n======  OH-MY-ZSH  ======\n" $DEFAULT
$PCKG_INSTALL awk
error_handling $? 
curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh > oh-my-zsh.sh
sed -i "s:env zsh:exit:g" oh-my-zsh.sh
chmod 755 oh-my-zsh.sh
./oh-my-zsh.sh
rm oh-my-zsh.sh
change_shell
error_handling $?
echo -e $YELLOW "\n======  TERMINATOR  ======\n" $DEFAULT 
$PCKG_INSTALL terminator
error_handling $?
echo -e $GREEN "\n======  Successfully installed term and shell config  ======\n" $DEFAULT

echo -e $BLUE '---------------------------\n  INSTALLING GCC\n---------------------------' $DEFAULT
$PCKG_INSTALL gcc
error_handling $?
echo -e $GREEN "\n======  Successfully installed gcc  ======\n" $DEFAULT

echo -e $BLUE '---------------------------\n  INSTALLING DOCKER \n---------------------------' $DEFAULT
$PCKG_INSTALL docker docker-compose
error_handling $?
echo -e $GREEN "\n======  Successfully installed docker  ======\n" $DEFAULT

echo -e $BLUE '---------------------------\n  SSH KEY GEN\n---------------------------' $DEFAULT
$PCKG_INSTALL openssh
echo -e $BLUE "LEAVE EVERYTHING AS DEFAULT" $DEFAULT
ssh-keygen
error_handling $?
echo -e $GREEN "\n======  SSH ready  ======\n" $DEFAULT

echo -e $BLUE '---------------------------\n  INSTALLING NODE\n---------------------------' $DEFAULT
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
$PCKG_INSTALL nodejs
error_handling $?
$PCKG_INSTALL npm
error_handling $?
echo -en $GREEN "NODE VERSION : " $(node -v) $DEFAULT
echo -en $GREEN "NPM VERSION : " $(npm -v) $DEFAULT
echo -e $GREEN "\n======  Successfully installed node  ======\n" $DEFAULT

echo -e $BLUE '---------------------------\n  INSTALLING TOOLS\n---------------------------' $DEFAULT
echo -e $YELLOW "\n======  VALGRIND  ======\n" $DEFAULT 
$PCKG_INSTALL valgrind
error_handling $?
echo -e $YELLOW "\n======  TREE  ======\n" $DEFAULT 
$PCKG_INSTALL tree
error_handling $?
echo -e $YELLOW "\n======  NCURSE  ======\n" $DEFAULT 
if [ $PCKG_MANAGER = 'apt-get' ]; then
    $PCKG_INSTALL libncurses5-dev libncursesw5-dev
elif [ $PCKG_MANAGER = 'pacman' ]; then
    $PCKG_INSTALL ncurses
fi
error_handling $?
echo -e $YELLOW "\n======  FIREFOX  ======\n" $DEFAULT 
$PCKG_INSTALL firefox
error_handling $?
echo -e $YELLOW "\n======  HTOP  ======\n" $DEFAULT 
$PCKG_INSTALL htop
error_handling $?
echo -e $YELLOW "\n======  ALIAS  ======\n" $DEFAULT
echo -e $YELLOW"adding cls for clear && ls"
echo "alias cls='clear; ls -l'" >> ~/.zshrc
echo "adding ne for emacs -nw"
echo "alias ne='emacs -nw'" >> ~/.zshrc
echo "adding dc for docker-compose"
echo "alias dc='docker-compose'" >> ~/.zshrc
echo -e "adding please for sudo" $DEFAULT
echo "alias please='sudo'" >> ~/.zshrc
echo -e $GREEN "\n======  Successfully installed tools  ======\n" $DEFAULT
