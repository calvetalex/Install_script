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
    echo -e $RED "======= No argument required =======" $DEFAULT
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
osInfo[/etc/debian_version]=apt
osInfo[/etc/arch-release]=pacman


for f in ${!osInfo[@]}
do
    if [[ -f $f ]];then
        echo -e $BLUE Package manager: ${osInfo[$f]} $DEFAULT
        PCKG_MANAGER=${osInfo[$f]}
    fi
done

if [ $PCKG_MANAGER == "pacman" ]; then
    PCKG_UPDATE='sudo pacman --noconfirm -Syyu'
    PCKG_INSTALL='sudo pacman --noconfirm -Sy'
elif [ $PCKG_MANAGER == "apt" ]; then
    PCKG_UPDATE='sudo apt update'
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
    current_shell=(`echo $0`)
    if [ "$current_shell" == "/usr/bin/zsh" ]; then
        return
    fi
    echo -en $YELLOW"Would you like to change to zsh ? [Y/n]"$DEFAULT
    read choice
    case $choice in
        n|N) return;;
        *) chsh $USER -s /usr/bin/zsh
    esac
}

function drawline {
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' $1
}

function begin {
    echo -e $BLUE
    drawline '-'
    echo "    $1"
    drawline '-'
    echo -e $DEFAULT
}

function success {
    echo -e $GREEN
    drawline '='
    echo "    $1"
    drawline '='
    echo -e $DEFAULT
}

function info {
    echo -e $YELLOW
    drawline '#'
    echo "=> $1"
    drawline '#'
    echo -e $DEFAULT
}

#------ INSTALL -------
begin "UPDATE SYSTEM"
$PCKG_UPDATE
error_handling $?
success "SYSTEM UP TO DATE"

begin "INSTALL CURL && WGET"
$PCKG_INSTALL curl
error_handling $?
$PCKG_INSTALL wget
error_handling $?
success "CURL && WGET READY"

begin "UPDATING PYTHON to PYTHON3"
$PCKG_INSTALL python3
error_handling $?
success "PYTHON READY"

begin "INSTALLING GIT"
$PCKG_INSTALL git
error_handling $?
success "SUCCESSFULLY INSTALLED GIT"

begin "INSTALLING EDITORS"
info "NANO"
$PCKG_INSTALL nano
error_handling $?
info "VIM"
$PCKG_INSTALL vim
error_handling $?
info "EMACS"
$PCKG_INSTALL emacs
error_handling $?
if [ "$PCKG_MANAGER" != "apt" ];then
    info "CODE"
    $PCKG_INSTALL code
    error_handling $?
fi
success "SUCCESSFULLY INSTALLED EDITORS"

begin "INSTALL TERMS && SHELL"
info "ZSH"
$PCKG_INSTALL zsh
error_handling $?
info "OH-MY-ZSH"
if [ "$PCKG_MANAGER" == "pacman" ];then
    $PCKG_INSTALL awk
    error_handling $?
fi
echo -e $RED"/!\\ Please, enter exit when zsh will start" $DEFAULT
curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh > oh-my-zsh.sh
sed -i "s:env zsh:exit:g" oh-my-zsh.sh
chmod 755 oh-my-zsh.sh
./oh-my-zsh.sh
rm oh-my-zsh.sh
change_shell
error_handling $?
begin "ADDING TERMS"
info "Terminator"
$PCKG_INSTALL terminator
error_handling $?
info "Tmux"
$PCKG_INSTALL tmux
error_handling $?
success "SUCCESSFULLY INSTALLED TERMS AND SHELL"

begin "GCC"
$PCKG_INSTALL gcc
error_handling $?
success "SUCCESSFULLY INSTALLED GCC"

begin "INSTALL DOCKER AND DOCKER-COMPOSE"
$PCKG_INSTALL docker docker-compose
error_handling $?
success "SUCCESSFULLY INSTALLED DOCKER AND DOCKER-COMPOSE"

begin "INSTALL SSH TOOLS"
$PCKG_INSTALL openssh
echo -e $BLUE "=> LEAVE EVERYTHING AS DEFAULT" $DEFAULT
ssh-keygen
error_handling $?
success "SSH READY"

begin "INSTALL NODE"
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
$PCKG_INSTALL nodejs
error_handling $?
$PCKG_INSTALL npm
error_handling $?
echo -en $GREEN "NODE VERSION : " $(node -v) $DEFAULT
echo -en $GREEN "NPM VERSION : " $(npm -v) $DEFAULT
success "SUCCESSFULLY INSTALLED NODE"

begin "INSTALL TOOLS"
info "Valgrind"
$PCKG_INSTALL valgrind
error_handling $?
info "Tree"
$PCKG_INSTALL tree
error_handling $?
info "NCURSE"
if [ $PCKG_MANAGER == 'apt' ]; then
    $PCKG_INSTALL libncurses5-dev libncursesw5-dev
elif [ $PCKG_MANAGER == 'pacman' ]; then
    $PCKG_INSTALL ncurses
fi
error_handling $?
info "Firefox"
$PCKG_INSTALL firefox
error_handling $?
info "HTOP"
$PCKG_INSTALL htop
error_handling $?
info "ALIAS"
echo -e $YELLOW"--> adding cls for clear && ls"
echo "alias cls='clear; ls -l'" >> ~/.zshrc
echo "--> adding ne for emacs -nw"
echo "alias ne='emacs -nw'" >> ~/.zshrc
echo "--> adding dc for docker-compose"
echo "alias dc='docker-compose'" >> ~/.zshrc
echo -e "--> adding please for sudo" $DEFAULT
echo "alias please='sudo'" >> ~/.zshrc
success "SUCCESSFULLY INSTALLED TOOLS"

echo -e $GREEN"\nComputer Ready - Please close and open a new terminal to see changes\n"$DEFAULT
