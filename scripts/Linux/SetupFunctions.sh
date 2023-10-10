#!/bin/bash

PERSONAL_CONFIGS="/home/${USERNAME}/dev/personal-configs"
USER_HOME="/home/${USERNAME}"
DEVELOPMENT_DIR="${USER_HOME}/dev"

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
    ln -sf ${PERSONAL_CONFIGS}/vim/.vimrc ${USER_HOME}/.vimrc
}

function setup_emacs() {
    apt install emacs-gtk -y

    # Remove ~/.emacs.d and replace with symlink to ~/dev/personal-configs
    rm ${USER_HOME}/.emacs.d || true
    ln -sf ${PERSONAL_CONFIGS}/emacs/.emacs.d/ ${USER_HOME}/.emacs.d
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
    systemctl enable syncthing@${USERNAME}.service
    systemctl start syncthing@${USERNAME}.service
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
    ln -sf ${PERSONAL_CONFIGS}/tmux/.tmux.conf ${USER_HOME}/.tmux.conf
}

# Setup suckless terminal
function setup_st() {
    local ST_DIR="${DEVELOPMENT_DIR}/st"

    git clone git://git.suckless.org/st ${ST_DIR}

    pushd ${ST_DIR}
    curl -O https://st.suckless.org/patches/dracula/st-dracula-0.8.5.diff
    curl -O https://st.suckless.org/patches/blinking_cursor/st-blinking_cursor-20230819-3a6d6d7.diff
    curl -O https://st.suckless.org/patches/desktopentry/st-desktopentry-0.8.5.diff

    patch -i st-dracula-0.8.5.diff
    patch -i st-blinking_cursor-20230819-3a6d6d7.diff
    patch -i st-desktopentry-0.8.5.diff
    patch -i ${PERSONAL_CONFIGS}/st/config.def.h.diff

    sudo make clean install

    popd
}
