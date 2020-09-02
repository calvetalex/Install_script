# Installation script

This script will install a basic env to work. More complete on arch, it also works on ubuntu but fewer packages will be installed. If you can install Arch linux.
You can add a config file with extensions name for code to the script to have them automatically installed. _Provide the full name of the form publisher.extension, for example ms-vscode.cpptools._

## USE
Clone the repo and run install.sh in the directory. Don t move any file and just let install.sh make the job. Reset after installation.
You can run *./init.sh -h* to know how work the script.

Known issues :
* node crash sometimes on ubuntu but node version avaible => Don t end the script
* code non-avaible for ubuntu => Install it with Ubuntu Software
* terminator non-avaible for ubuntu => Install it with Ubuntu Software
* docker on ubuntu => Install it manually
* docker-compose on ubuntu => Install it manually
* tree => bad repo on ubuntu

Tested on archlinux/base docker image (https://hub.docker.com/u/archlinux), manjaro (https://manjaro.org/download/deepin/) and ubuntu 18.04 (https://ubuntu.com/download/desktop)

### This scipt will install a basic env to work

* Will Install:
    * emacs
        * neotree
        * smooth scrolling
        * whitspace mode
        * auto-complete
        * Flycheck
    * nano
    * docker && docker-compose (for arch)
    * code (for arch)
        * extension git history
        * extension git lens
        * extension git-graph
        * extension live share
        * extension TODO highlight
        * extension C/C++ tools
        * extension eslint (norme for JS)
        * extension material icon (to have a better visuel)
        * feat : you can add custom extensions (for this please enter ```./install.sh file```, where file is a list of full extensions names: publisher.extension)
    * node
    * terminator (for arch)
    * tmux
    * firefox
    * ssh
    * valgrind
    * git
       * git lg (a prettier git log)
    * gcc
    * python3
    * go
    * add zsh
    * add oh-my-zsh
    * basics alias¹
    * tree
    * htop
    * lib ncurse
    * cmake
    * links

For arch user, will install yay.

¹: alias cls="clear ; ls" / alias ne="emacs -nw" / alias dkc="sudo docker-compose" / alias please="sudo"
