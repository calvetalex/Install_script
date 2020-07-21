#! /bin/bash

#----- COLOR --------
RED='\033[1;31m'
YELLOW='\033[1;93m'
GREEN='\033[1;32m'
BLUE='\033[1;36m'
DEFAULT='\033[00m'

#------- USEFUL FUNCTIONS ------

function usage
{
    echo -e $BLUE
    echo "USAGE:"
    echo -e "\t./install.sh [-h] [extensions file]"
    echo "DESCRIPTION:"
    echo -e "\t-h\t\t\tdisplay help"
    echo -e "\textensions file\t\tpath to file with on extension name per line, only avaible on arch"
    echo -e $DEFAULT
}

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

function default_extensions {
        echo -e $YELLOW"--> cpptools extension"$DEFAULT
        code --install-extension ms-vscode.cpptools
        error_handling $?
        echo -e $YELLOW"--> eslint extension"$DEFAULT
        code --install-extension dbaeumer.vscode-eslint
        error_handling $?
        echo -e $YELLOW"--> git-graph extension"$DEFAULT
        code --install-extension mhutchie.git-graph
        error_handling $?
        echo -e $YELLOW"--> git history extension"$DEFAULT
        code --install-extension donjayamanne.githistory
        error_handling $?
        echo -e $YELLOW"--> git lens extension"$DEFAULT
        code --install-extension eamodio.gitlens
        error_handling $?
        echo -e $YELLOW"--> live share extension"$DEFAULT
        code --install-extension ms-vsliveshare.vsliveshare
        error_handling $?
        echo -e $YELLOW"--> TODO highlight extension"$DEFAULT
        code --install-extension wayou.vscode-todo-highlight
        error_handling $?
        echo -e $YELLOW"--> material icon extension"$DEFAULT
        code --install-extension pkief.material-icon-theme
        error_handling $?
        echo -e $YELLOW"--> bracket pair colorized 2"$DEFAULT
        code --install-extension coenraads.bracket-pair-colorizer-2
        error_handling $?
}

function install_extensions
{
        echo -en $BLUE"Do you want to install default extensions too ?[Y|n]"$DEFAULT
        read choice
        case $choice in
            n|N) return;;
            *) default_extensions;;
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

function etipek {
    info "INSTALLING BLIH"
    curl https://raw.githubusercontent.com/kayofeld/script-installation-ordinateur-epitech/master/installation/.files/blih > blih.py
    if [ $? -eq 0 ]; then
        chmod +x blih.py
        sudo mv blih.py /bin/blih
    else
        echo -en $RED "[AN ERROR OCCURRED]" $DEFAULT "Blih was not installed"
        return;
    fi
    info "UPLOAD SSH KEY"
    read -p "Enter your epitech address: " email
    blih -u $email sshkey upload ~/.ssh/id_rsa.pub
}

function epitech_install {
    echo "Are you an EPITECH student ? [Y|n]"
    read answer
    case $answer in
        n|N) return;;
        *) etipek
    esac
}

#------ FIRST ERROR HANDLING -------

# Verify user
if [ "$(id -u)" == "0" ]; then
    echo -e $RED "====== Don't run this as root =======" $DEFAULT
    exit 84
fi


# Verify cmd entered
if [ $# -ne 0 ]; then
    if [ "$1" == "-h" ];then
        usage
        exit 0
    elif [ -f "$1" ]; then
        EXTENSIONS="$1"
    else
        echo -e $RED "======= START ERROR: TRY ./install.sh -h =======" $DEFAULT
        exit 84
    fi
fi

# Verify necessary files
if [ ! -f "./install_files/oh-my-zsh.sh" ]; then
    echo -e $RED"Please run the script in his directory"$DEFAULT
    exit 84
fi

if [ ! -d "./install_files/.emacs.d" ]; then
    echo -e $RED"Please run the script in his directory"$DEFAULT
    exit 84
fi

#--------ENV-------

# Check if os is a linux
OS=(`uname`)
if [ $OS = "Linux" ]; then
    echo -e $BLUE "You are using a $OS !\n\tWELCOME\n" $DEFAULT
else
    echo -e $RED "Only Linux is supported\n" $DEFAULT
    exit 84
fi

# Get package manager
declare -A osInfo;
osInfo[/etc/debian_version]=apt-get
osInfo[/etc/arch-release]=pacman

for f in ${!osInfo[@]}
do
    if [[ -f $f ]];then
        echo -e $BLUE Package manager: ${osInfo[$f]} $DEFAULT
        PCKG_MANAGER=${osInfo[$f]}
        if [ "$PCKG_MANAGER" != "pacman" ];then
            echo -e $RED"You should redump on Arch"$DEFAULT
        fi
    fi
done

# Up package manager, install cmd and update cmd
if [ $PCKG_MANAGER == "pacman" ]; then
    PCKG_UPDATE='sudo pacman --noconfirm -Syyu'
    PCKG_INSTALL='sudo pacman --noconfirm -Sy'
elif [ $PCKG_MANAGER == "apt-get" ]; then
    PCKG_UPDATE='sudo apt-get update'
    PCKG_INSTALL='sudo apt-get -y install'
else
    echo -e $RED "Package manager not supported\n" $DEFAULT
    exit 84
fi

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

if [ "$PCKG_MANAGER" == "pacman" ]; then
begin "INSTALL GOLANG"
$PCKG_INSTALL go
error_handling $?
success "GOLANG"
fi

begin "INSTALLING GIT"
$PCKG_INSTALL git
error_handling $?
info "INSTALL git lg alias for a better git log"
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
success "SUCCESSFULLY INSTALLED GIT"

begin "INSTALLING EDITORS"
info "NANO"
$PCKG_INSTALL nano
error_handling $?
info "enable color in nano...."
find /usr/share/nano/ -iname "*.nanorc" -exec echo include {} \; >> ~/.nanorc
info "VIM"
$PCKG_INSTALL vim
error_handling $?
info "EMACS"
$PCKG_INSTALL emacs
error_handling $?
cp -r install_files/.emacs.d ~
error_handling $?
cp install_files/.emacs.d/.emacs ~
error_handling $?
if [ "$PCKG_MANAGER" == "pacman" ];then
    info "CODE"
    $PCKG_INSTALL code
    error_handling $?
    if [ -z "$EXTENSIONS" ]; then
        default_extensions
    else
        install_extensions
        echo -e $YELLOW"--> Installing custom extensions"$DEFAULT
        for extension in $(cat $EXTENSIONS);do
            code --install-extension $extension
            error_handling $?
        done
    fi
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
./install_files/oh-my-zsh.sh
error_handling $?
begin "ADDING TERMS"
if [ "$PCKG_MANAGER" == "pacman" ]; then
    info "Terminator"
    $PCKG_INSTALL terminator
    error_handling $?
fi
info "Tmux"
$PCKG_INSTALL tmux
error_handling $?
success "SUCCESSFULLY INSTALLED TERMS AND SHELL"

begin "GCC"
$PCKG_INSTALL gcc
error_handling $?
success "SUCCESSFULLY INSTALLED GCC"

if [ "$PCKG_MANAGER" == "pacman" ];then
    begin "INSTALL DOCKER AND DOCKER-COMPOSE"
    $PCKG_INSTALL docker docker-compose
    error_handling $?
    systemctl start docker.service
    error_handling $?
    cp -rf ./install_files/test_project ~
    echo -e "$BLUE You can now test your projects in ~/test_projects on dockers\n default Dockers: ubuntu, archlinux/base and fedora $DEFAULT" 
    success "SUCCESSFULLY INSTALLED DOCKER AND DOCKER-COMPOSE"
fi

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
info "Cmake"
if [ "$PCKG_MANAGER" ==  "pacman" ];then
    $PCKG_INSTALL cmake
    error_handling $?
elif [ "$PCKG_MANAGER" == "apt-get" ]; then
    sudo apt-get install software-properties-common
    sudo add-apt-repository ppa:george-edison55/cmake-3.x
    sudo apt-get update
    sudo apt-get install cmake
fi
info "Tree"
$PCKG_INSTALL tree
error_handling $?
info "NCURSE"
if [ $PCKG_MANAGER == 'apt-get' ]; then
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
info "BROWSER WEB IN TERM"
$PCKG_INSTALL links
error_handling $?
info "ALIAS"
echo -e $YELLOW"--> adding cls for clear && ls"
echo "alias cls='clear; ls -l'" >> ~/.zshrc
echo "--> adding ne for emacs -nw"
echo "alias ne='emacs -nw'" >> ~/.zshrc
echo "--> adding dkc for docker-compose"
echo "alias dkc='sudo docker-compose'" >> ~/.zshrc
echo -e "--> adding please for sudo" $DEFAULT
echo "alias please='sudo'" >> ~/.zshrc
echo -e "--> adding reload cmd" $DEFAULT
echo "alias reload='source ~/.zshrc'" >> ~/.zshrc
success "SUCCESSFULLY INSTALLED TOOLS"

begin "EPITECH CONFIG"
epitech_install
success "EPITECH INSTALL COMPLETE"

echo -e $GREEN"\nComputer Ready - Please close and open a new terminal to see changes\n"$DEFAULT
