#!/bin/bash

# Chromium
sudo apt-get install chromium

# Curl
sudo apt-get install curl

# Xclip
sudo apt-get install xclip

# Syncthing
# Add the release PGP keys:
curl -s https://syncthing.net/release-key.txt | sudo apt-key add -

# Add the "stable" channel to your APT sources:
echo "deb https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list

# Update and install syncthing:
sudo apt-get update
sudo apt-get install syncthing

# Add syncthing to systemd
sudo cp /lib/systemd/system/syncthing@.service ./syncthing.service
sudo systemctl enable syncthing

# Install Emacs

# Remove ~/.emacs.d and replace with symlink to ~/dev/personal-configs
# DELETE ~/.emacs.d
ln -s ~/dev/personal-configs/emacs/.emacs.d/ ~/.emacs.d

# Link .zshrc
rm ~/.zshrc
ln -s ~/dev/personal-configs/zsh/.zshrc ~/.zshrc

# Add bash-git-prompt
git clone https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompt --depth=1

# Add case insensitive auto-completion
if grep -qi completion-ignore-case /etc/inputrc; then
    echo -e "\ncompletion-ignore-case already set to On"
else
    echo -e "\nset completion-ignore-case On" | sudo tee -a /etc/inputrc
fi

# Install latex related packages
sudo apt install texlive-latex-base texlive-latex-recommended texlive-fonts-recommended texlive-latex-extra

# Install packages necessary for native emacs compilation
sudo apt-get install build-essential texinfo libx11-dev libxpm-dev libjpeg-dev libpng-dev libgif-dev libtiff-dev libgtk2.0-dev libncurses-dev automake autoconf libgccjit0 libgccjit-10-dev

# For CPU Topology tool lstopo
sudo apt install hwloc
