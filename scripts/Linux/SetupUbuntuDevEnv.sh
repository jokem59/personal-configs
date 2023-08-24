#!/bin/bash

# Abort on non-zero exit status, abort on unbound variable, don't hide errors in pipes
set -euo pipefail

# Replace usage of PulseAudio with Pipewire (supports Bluetooth Headset + Headset Microphone without bad audio quality)
# Source: https://linuxconfig.org/how-to-install-pipewire-on-ubuntu-linux
function enable_pipewire() {
    add-apt-repository ppa:pipewire-debian/pipewire-upstream
    apt update
    apt install pipewire pipewire-audio-client-libraries

    apt install gstreamer1.0-pipewire libpipewire-0.3-{0,dev,modules} libspa-0.2-{bluetooth,dev,jack,modules} pipewire{,-{audio-client-libraries,pulse,media-session,bin,locales,tests}}

    systemctl --user daemon-reload
    systemctl --user --now disable pulseaudio.service pulseaudio.socket
    systemctl --user --now enable pipewire pipewire-pulse

    pactl info
}

function revert_pipewire() {
    apt remove pipewire pipewire-audio-client-libraries
    apt remove gstreamer1.0-pipewire libpipewire-0.3-{0,dev,modules} libspa-0.2-{bluetooth,dev,jack,modules} pipewire{,-{audio-client-libraries,pulse,media-session,bin,locales,tests}}

    systemctl --user daemon-reload
    systemctl --user --now enable pulseaudio.service pulseaudio.socket

    pactl info
}

function emacs_native_compilation_packages() {
    # Install packages necessary for native emacs compilation
    apt-get install build-essential texinfo libx11-dev libxpm-dev libjpeg-dev libpng-dev libgif-dev libtiff-dev libgtk2.0-dev libncurses-dev automake autoconf libgccjit0 libgccjit-10-dev
}

function get_latex_packages() {
    # Install latex related packages
    apt install texlive-full -y
}

function setup_vim() {
    apt install vim -y

    # Remove ~/.vimrc and replace with symlink to to ~/dev/personal-configs
    rm ${USER_HOME}/.vimrc || true
    ln -s ${PERSONAL_CONFIGS}/vim/.vimrc ${USER_HOME}/.vimrc
}

function setup_emacs() {
    apt install emacs-gtk -y

    # Remove ~/.emacs.d and replace with symlink to ~/dev/personal-configs
    rm ${USER_HOME}/.emacs.d || true
    ln -s ${PERSONAL_CONFIGS}/emacs/.emacs.d/ ${USER_HOME}/.emacs.d
}

function setup_syncthing() {
    # Add the release PGP keys:
    curl -s https://syncthing.net/release-key.txt | sudo apt-key add -

    # Add the "stable" channel to your APT sources:
    echo "deb https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list

    # Update and install syncthing:
    apt update
    apt install syncthing -y

    # Add syncthing to systemd and start it
    systemctl enable syncthing@${real_user}.service
    systemctl start syncthing@${real_user}.service
}

function setup_gnome_terminal() {
    local mgt_dir="/tmp/monokai-gnome-terminal"
    apt install dconf-cli -y

    rm -rf ${mgt_dir} || true
    git clone https://github.com/0xComposure/monokai-gnome-terminal ${mgt_dir}
    ${mgt_dir}/install.sh

    local roboto_dst_dir='/usr/share/fonts/truetype/robotomono'
    rm -rf ${roboto_dst_dir} || true
    mkdir ${roboto_dst_dir}
    cp ${PERSONAL_CONFIGS}/fonts/robotomono/static/* ${roboto_dst_dir}

    dconf load ${PERSONAL_CONFIGS}/gnome-terminal/ < ${PERSONAL_CONFIGS}/gnome-terminal/gterminal.preferences
}

# Settings for gnome + gnome tweaks
function setup_gnome_settings() {
    dconf load ${PERSONAL_CONFIGS}/ghome-settings/ < ${PERSONAL_CONFIGS}/gnome-settings/gnome_settings.dconf
}

function setup_tmux() {
    apt install tmux -y

    rm ${USER_HOME}/.tmux.conf || true
    ln -s ${PERSONAL_CONFIGS}/tmux/.tmux.conf ${USER_HOME}/.tmux.conf
}

############
### Main ###
############
# NOTE: Need to setup zsh separately
# Usage: sudo ./SetupUbuntuDevEnv.sh -u $(echo $USERNAME)

while getopts u: opt; do
    case $opt in
        u) real_user=$OPTARG ;;
        *)
             echo 'Error in command line parsing' >&2
             exit 1
    esac
done

shift "$(( OPTIND - 1 ))"

if [ -z "$real_user" ]; then
    echo 'Missing -u <username>' >&2
    exit 1
fi

if ! [ $(id -u) = 0 ]; then
   echo "The script need to be run as root." >&2
   exit 1
fi

echo
echo "INFO: Script is run with username ${real_user}"

# Commands that you don't want running as root would be invoked
# with: sudo -u $real_user
# So they will be run as the user who invoked the sudo command
# Keep in mind if the user is using a root shell (they're logged in as root),
# then $real_user is actually root
# sudo -u $real_user non-root-command

# Commands that need to be ran with root would be invoked without sudo
# root-command

PERSONAL_CONFIGS="/home/${real_user}/dev/personal-configs"
USER_HOME="/home/${real_user}"
read -p "Has personal-configs been cloned to ${PERSONAL_CONFIGS}? " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

# hwloc = lstopo
apt install curl wget xclip tmux gnome-tweaks ripgrep shellcheck htop hwloc dconf-cli blueman gnome-clocks convert plocate -y

setup_emacs
setup_vim
setup_gnome_terminal
setup_tmux
setup_syncthing
setup_gnome_settings
get_latex_packages

# Add case insensitive auto-completion
if grep -qi completion-ignore-case /etc/inputrc; then
    echo -e "\ncompletion-ignore-case already set to On"
else
    echo -e "\nset completion-ignore-case On" | sudo tee -a /etc/inputrc
fi

