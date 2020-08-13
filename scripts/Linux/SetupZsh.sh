#!/bin/bash

sudo apt-get update

sudo apt-get install zsh

sudo usermod -s /usr/bin/zsh $(whoami)

sudo shutdown -r now

sudo apt-get install powerline fonts-powerline
sudo apt-get install zsh-theme-powerlevel9k

sudo apt-get install zsh-syntax-highlighting

# TODO: Test on next Linux environment setup - OhMyZsh was working already in current setup
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/
install.sh -O -)"
