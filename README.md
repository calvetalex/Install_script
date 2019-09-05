# Installation script

This script will install a basic env to work. More complete on arch, it also works on ubuntu but fewer packages will be installed.

## USE
Clone the repo and run install.sh in the directory. Install.sh and oh-my-zsh.sh *MUST* be in the same directory.

Known issues : 
* node crash but installed on ubuntu => TODO
* code non-avaible for ubuntu => Install it with Ubuntu Software

Tested on archlinux/base docker image (https://hub.docker.com/u/archlinux), manjaro (https://manjaro.org/download/deepin/) and ubuntu 18.04 (https://ubuntu.com/download/desktop)

### This scipt will install a basic env to work

* Will Install:
    * emacs
        * emacs neotree
        * emacs smooth scrolling
        * whitspace mode
    * nano
    * docker && docker-compose
    * code (for arch)
    * node
    * terminator
    * firefox
    * ssh
    * valgrind
    * git
    * gcc
    * python3
* Will Update :
    * add zsh
    * add oh-my-zsh
    * basics alias¹
    * tree
    * htop
    * lib ncurse

¹: alias cls="clear ; ls" / alias ne="emacs -nw" / alias dc="docker-compose" / alias please="sudo"
