# Installation script

This script will install a basic env to work. More complete on arch, it also works on ubuntu but fewer packages will be installed. If you can install Arch linux

## USE
Clone the repo and run install.sh in the directory. Install.sh and oh-my-zsh.sh *MUST* be in the same directory.

Known issues : 
* node crash sometimes on ubuntu => TODO
* code non-avaible for ubuntu => Install it with Ubuntu Software
* terminator non-avaible for ubuntu => Install it with Ubuntu Software
* docker on ubuntu => Install it manually
* docker-compose on ubuntu => Install it manually
* tree => bad repo on ubuntu

Tested on archlinux/base docker image (https://hub.docker.com/u/archlinux), manjaro (https://manjaro.org/download/deepin/) and ubuntu 18.04 (https://ubuntu.com/download/desktop)

### This scipt will install a basic env to work

* Will Install:
    * emacs
        * emacs neotree
        * emacs smooth scrolling
        * whitspace mode
    * nano
    * docker && docker-compose (for arch)
    * code (for arch)
    * node
    * terminator (for arch)
    * tmux
    * firefox
    * ssh
    * valgrind
    * git
    * gcc
    * python3
    * add zsh
    * add oh-my-zsh
    * basics alias¹
    * tree
    * htop
    * lib ncurse
    * cmake



¹: alias cls="clear ; ls" / alias ne="emacs -nw" / alias dc="docker-compose" / alias please="sudo"
