#!/bin/bash

SUDO_USER_HOME=""
if [ -n "${SUDO_USER:-}" ]; then
    SUDO_USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6 || echo "")
fi
USER_HOME="${SUDO_USER_HOME:-$HOME}"
USERNAME="${SUDO_USER:-$USER}"
DEVELOPMENT_DIR="${USER_HOME}/dev"

if [ -z "${PERSONAL_CONFIGS:-}" ]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    PERSONAL_CONFIGS="$(cd "${SCRIPT_DIR}/../.." && pwd)"
fi


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
    # Install latex related packages without ConTeXt to avoid the known MarkIV pregeneration hang
    apt install texlive-latex-base texlive-latex-recommended texlive-fonts-recommended texlive-latex-extra texlive-fonts-extra texlive-xetex texlive-luatex latexmk -y
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
    apt install dconf-cli -y

    local roboto_dst_dir='/usr/share/fonts/truetype/robotomono'
    if [ "${DRY_RUN:-}" = "true" ]; then
        echo "[DRY RUN] rm -rf ${roboto_dst_dir}"
        echo "[DRY RUN] mkdir -p ${roboto_dst_dir}"
        echo "[DRY RUN] cp ${PERSONAL_CONFIGS}/fonts/robotomono/static/* ${roboto_dst_dir}"
        echo "[DRY RUN] sudo -u ${USERNAME} -i dconf load /org/gnome/terminal/ < ${PERSONAL_CONFIGS}/gnome-terminal/gterminal.preferences"
    else
        rm -rf ${roboto_dst_dir} || true
        mkdir -p ${roboto_dst_dir}
        cp ${PERSONAL_CONFIGS}/fonts/robotomono/static/* ${roboto_dst_dir}

        # Load GNOME terminal preferences as the target user
        sudo -u ${USERNAME} -i dconf load /org/gnome/terminal/ < ${PERSONAL_CONFIGS}/gnome-terminal/gterminal.preferences
    fi
}

# Settings for gnome + gnome tweaks
function setup_gnome_settings() {
    if [ "${DRY_RUN:-}" = "true" ]; then
        echo "[DRY RUN] sudo -u ${USERNAME} -i dconf load / < ${PERSONAL_CONFIGS}/gnome-settings/gnome_settings.dconf"
    else
        # Load GNOME settings as the target user (keys in the dconf file are absolute, so load at /)
        sudo -u ${USERNAME} -i dconf load / < ${PERSONAL_CONFIGS}/gnome-settings/gnome_settings.dconf
    fi
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

function setup_alacritty() {
    # On older Ubuntu, alacritty might not be in official repos, check if ppa is needed
    if apt-cache policy alacritty 2>/dev/null | grep -q "Candidate: (none)"; then
        echo "Alacritty has no installation candidate. Adding aslatter PPA..."
        # Wrap add-apt-repository in a timeout to handle connection hangs
        if ! command -v timeout &>/dev/null || ! timeout 15 add-apt-repository ppa:aslatter/ppa -y; then
            echo "add-apt-repository timed out or failed. Attempting manual repository configuration..."
            echo "deb http://ppa.launchpad.net/aslatter/ppa/ubuntu focal main" | tee /etc/apt/sources.list.d/aslatter-ppa.list >/dev/null
            curl -s "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x52B24DF7D43B5377" | gpg --homedir /tmp --dearmor | tee /etc/apt/trusted.gpg.d/aslatter-ppa.gpg >/dev/null
        fi
        apt update
    fi
    apt install alacritty -y

    # Ensure config directory exists
    mkdir -p "${USER_HOME}/.config/alacritty"

    # Symlink config
    rm -f "${USER_HOME}/.config/alacritty/alacritty.toml"
    ln -sf "${PERSONAL_CONFIGS}/alacritty/alacritty.toml" "${USER_HOME}/.config/alacritty/alacritty.toml"
    
    # Symlink themes and themes-pack if they exist
    rm -rf "${USER_HOME}/.config/alacritty/themes" || true
    if [ -d "${PERSONAL_CONFIGS}/alacritty/themes" ]; then
        ln -sf "${PERSONAL_CONFIGS}/alacritty/themes" "${USER_HOME}/.config/alacritty/themes"
    fi
    
    rm -rf "${USER_HOME}/.config/alacritty/themes-pack" || true
    if [ -d "${PERSONAL_CONFIGS}/alacritty/themes-pack" ]; then
        ln -sf "${PERSONAL_CONFIGS}/alacritty/themes-pack" "${USER_HOME}/.config/alacritty/themes-pack"
    fi

    # Fix ownership
    chown -R ${USERNAME}:${USERNAME} "${USER_HOME}/.config/alacritty"
}

function setup_helix() {
    # On older Ubuntu, helix might not be in official repos, check if ppa is needed
    if ! apt-cache show helix &>/dev/null; then
        add-apt-repository ppa:maveonair/helix -y
        apt update
    fi
    apt install helix -y

    # Ensure config directory exists
    mkdir -p "${USER_HOME}/.config/helix"

    # Symlink configs
    rm -f "${USER_HOME}/.config/helix/config.toml"
    ln -sf "${PERSONAL_CONFIGS}/helix/config.toml" "${USER_HOME}/.config/helix/config.toml"

    rm -f "${USER_HOME}/.config/helix/languages.toml"
    ln -sf "${PERSONAL_CONFIGS}/helix/languages.toml" "${USER_HOME}/.config/helix/languages.toml"

    # Fix ownership
    chown -R ${USERNAME}:${USERNAME} "${USER_HOME}/.config/helix"
}

function setup_rust() {
    # Check if rustup is already installed for the user
    if ! sudo -u ${USERNAME} -i command -v rustup &>/dev/null; then
        echo "Installing Rust/Cargo..."
        sudo -u ${USERNAME} -i curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sudo -u ${USERNAME} -i sh -s -- -y
    fi

    echo "Adding rust-src component..."
    sudo -u ${USERNAME} -i rustup component add rust-src

    # Check if rust-analyzer is already installed
    if ! sudo -u ${USERNAME} -i command -v rust-analyzer &>/dev/null; then
        echo "Installing rust-analyzer..."
        local ra_dir="${USER_HOME}/dev/rust-analyzer"
        # Ensure dev directory exists
        sudo -u ${USERNAME} -i mkdir -p "${USER_HOME}/dev"
        sudo -u ${USERNAME} -i rm -rf "$ra_dir"
        sudo -u ${USERNAME} -i git clone https://github.com/rust-analyzer/rust-analyzer.git "$ra_dir"
        
        # Build and install (need to run in user context so it uses user's cargo registry)
        sudo -u ${USERNAME} -i bash -c "cd '$ra_dir' && cargo xtask install --server"
        sudo -u ${USERNAME} -i rm -rf "$ra_dir"
    else
        echo "rust-analyzer is already installed. Skipping."
    fi
}

function setup_gitu() {
    # Check if cargo is installed
    if ! sudo -u ${USERNAME} -i command -v cargo &>/dev/null; then
        echo "Cargo is not installed. Installing Rust first..."
        setup_rust
    fi
    # Check if gitu is already installed
    if ! sudo -u ${USERNAME} -i command -v gitu &>/dev/null; then
        echo "Installing gitu via cargo..."
        sudo -u ${USERNAME} -i cargo install gitu
    else
        echo "gitu is already installed. Skipping."
    fi
}


