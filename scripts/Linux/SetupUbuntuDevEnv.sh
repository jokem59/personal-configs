#!/bin/bash

# Replace usage of PulseAudio with Pipewire (supports Bluetooth Headset + Headset Microphone without bad audio quality)
# Source: https://linuxconfig.org/how-to-install-pipewire-on-ubuntu-linux
function enable_pipewire() {
    sudo add-apt-repository ppa:pipewire-debian/pipewire-upstream
    sudo apt update
    sudo apt install pipewire pipewire-audio-client-libraries

    sudo apt install gstreamer1.0-pipewire libpipewire-0.3-{0,dev,modules} libspa-0.2-{bluetooth,dev,jack,modules} pipewire{,-{audio-client-libraries,pulse,media-session,bin,locales,tests}}

    systemctl --user daemon-reload
    systemctl --user --now disable pulseaudio.service pulseaudio.socket
    systemctl --user --now enable pipewire pipewire-pulse

    pactl info
}

function revert_pipewire() {
    sudo apt remove pipewire pipewire-audio-client-libraries
    sudo apt remove gstreamer1.0-pipewire libpipewire-0.3-{0,dev,modules} libspa-0.2-{bluetooth,dev,jack,modules} pipewire{,-{audio-client-libraries,pulse,media-session,bin,locales,tests}}

    systemctl --user daemon-reload
    systemctl --user --now enable pulseaudio.service pulseaudio.socket

    pactl info
}

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

enable_pipewire

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
