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
    if [ "${DRY_RUN:-}" = "true" ]; then
        echo "[DRY RUN] apt install tmux fzf git -y"
        echo "[DRY RUN] Would remove ${USER_HOME}/.tmux.conf"
        echo "[DRY RUN] Would clone/update oh-my-tmux at ${USER_HOME}/.local/share/tmux/oh-my-tmux"
        echo "[DRY RUN] Would create directory ${USER_HOME}/.config/tmux"
        echo "[DRY RUN] Would symlink tmux.conf and tmux.conf.local"
        echo "[DRY RUN] Would clone/update tmux-resurrect, tmux-continuum, tmux-thumbs to ${USER_HOME}/dev"
        echo "[DRY RUN] Would build tmux-thumbs with cargo (installing Rust first if needed)"
    else
        apt install tmux fzf git -y

        rm -f "${USER_HOME}/.tmux.conf"
        sudo -u ${USERNAME} -i git clone https://github.com/gpakosz/.tmux.git "${USER_HOME}/.local/share/tmux/oh-my-tmux" 2>/dev/null || (cd "${USER_HOME}/.local/share/tmux/oh-my-tmux" && sudo -u ${USERNAME} -i git pull)
        sudo -u ${USERNAME} -i mkdir -p "${USER_HOME}/.config/tmux"
        sudo -u ${USERNAME} -i ln -sf "${USER_HOME}/.local/share/tmux/oh-my-tmux/.tmux.conf" "${USER_HOME}/.config/tmux/tmux.conf"
        sudo -u ${USERNAME} -i ln -sf "${PERSONAL_CONFIGS}/tmux/.tmux.conf.local" "${USER_HOME}/.config/tmux/tmux.conf.local"

        # tmux plugins
        sudo -u ${USERNAME} -i mkdir -p "${USER_HOME}/dev"
        sudo -u ${USERNAME} -i git clone https://github.com/tmux-plugins/tmux-resurrect "${USER_HOME}/dev/tmux-resurrect" 2>/dev/null || (cd "${USER_HOME}/dev/tmux-resurrect" && sudo -u ${USERNAME} -i git pull)
        sudo -u ${USERNAME} -i git clone https://github.com/tmux-plugins/tmux-continuum "${USER_HOME}/dev/tmux-continuum" 2>/dev/null || (cd "${USER_HOME}/dev/tmux-continuum" && sudo -u ${USERNAME} -i git pull)
        sudo -u ${USERNAME} -i git clone https://github.com/fcsonline/tmux-thumbs "${USER_HOME}/dev/tmux-thumbs" 2>/dev/null || (cd "${USER_HOME}/dev/tmux-thumbs" && sudo -u ${USERNAME} -i git pull)

        # We need rust/cargo to build tmux-thumbs. If not installed, we can run setup_rust
        if ! sudo -u ${USERNAME} -i command -v cargo &>/dev/null; then
            echo "Cargo not found. Installing Rust first to build tmux-thumbs..."
            setup_rust
        fi

        echo "Building tmux-thumbs..."
        sudo -u ${USERNAME} -i bash -c "cd ${USER_HOME}/dev/tmux-thumbs && cargo build --release"
    fi
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

    # Build tmux-thumbs if it was cloned but cargo wasn't available at the time
    if [ -d "${USER_HOME}/dev/tmux-thumbs" ] && ! [ -f "${USER_HOME}/dev/tmux-thumbs/target/release/tmux-thumbs" ]; then
        echo "Building tmux-thumbs..."
        sudo -u ${USERNAME} -i bash -c "cd '${USER_HOME}/dev/tmux-thumbs' && cargo build --release"
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

# LSP servers for Emacs (eglot auto-starts any that are installed; see
# emacs/.emacs.d/lisp/init-eglot.el) and Helix. rust-analyzer comes from
# setup_rust. Python prefers a project's own .venv/bin/ty; this is the fallback.
function setup_language_servers() {
    local arch
    case "$(uname -m)" in
        aarch64|arm64) arch="arm64" ;;
        *) arch="x64" ;;
    esac

    if [ "${DRY_RUN:-}" = "true" ]; then
        echo "[DRY RUN] apt install clangd golang-go pipx nodejs npm -y (NodeSource LTS if apt's node < 18)"
        echo "[DRY RUN] npm install -g typescript typescript-language-server bash-language-server yaml-language-server vscode-langservers-extracted"
        echo "[DRY RUN] As ${USERNAME}: go install gopls, pipx install ty, cargo install taplo-cli"
        echo "[DRY RUN] Would download marksman and lua-language-server (linux-${arch}) into /usr/local"
        return 0
    fi

    apt install clangd golang-go pipx nodejs npm -y

    # The npm-based servers need Node >= 18; older Ubuntu ships much older.
    local node_major
    node_major=$(node -p 'process.versions.node.split(".")[0]' 2>/dev/null || echo 0)
    if [ "$node_major" -lt 18 ]; then
        echo "apt's Node is v${node_major}; installing the NodeSource LTS build..."
        curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
        apt install nodejs -y
    fi
    npm install -g typescript typescript-language-server bash-language-server \
        yaml-language-server vscode-langservers-extracted

    # Per-user installs: ~/go/bin (init-tools.el adds it to Emacs's exec-path),
    # ~/.local/bin, ~/.cargo/bin.
    sudo -u ${USERNAME} -i go install golang.org/x/tools/gopls@latest \
        || echo "Warning: gopls install failed (it needs Go >= 1.21; apt's golang-go may be older)."
    sudo -u ${USERNAME} -i pipx install ty || sudo -u ${USERNAME} -i pipx upgrade ty
    if ! sudo -u ${USERNAME} -i command -v cargo &>/dev/null; then
        echo "Cargo not found. Installing Rust first to build taplo..."
        setup_rust
    fi
    sudo -u ${USERNAME} -i cargo install taplo-cli --locked

    # No apt packages for these two; use the GitHub release builds.
    if ! command -v marksman &>/dev/null; then
        curl -fsSL -o /usr/local/bin/marksman \
            "https://github.com/artempyanykh/marksman/releases/latest/download/marksman-linux-${arch}"
        chmod +x /usr/local/bin/marksman
    fi
    if ! command -v lua-language-server &>/dev/null; then
        local lua_url
        lua_url=$(curl -fsSL https://api.github.com/repos/LuaLS/lua-language-server/releases/latest \
            | grep -o "https://[^\"]*-linux-${arch}\.tar\.gz" | head -1)
        rm -rf /opt/lua-language-server
        mkdir -p /opt/lua-language-server
        curl -fsSL "$lua_url" | tar -xz -C /opt/lua-language-server
        ln -sf /opt/lua-language-server/bin/lua-language-server /usr/local/bin/lua-language-server
    fi
}
function setup_mo() {
    # Ensure config directory exists
    mkdir -p "${USER_HOME}/.config/mo"

    # Symlink config
    rm -f "${USER_HOME}/.config/mo/config.toml"
    ln -sf "${PERSONAL_CONFIGS}/mo/config.toml" "${USER_HOME}/.config/mo/config.toml"

    # Fix ownership
    chown -R ${USERNAME}:${USERNAME} "${USER_HOME}/.config/mo"
}

function setup_claude_skills() {
    # Symlink each Claude Code skill from the repo into ~/.claude/skills so it is
    # reusable across machines. -n so re-runs replace the link, not nest inside it.
    mkdir -p "${USER_HOME}/.claude/skills"
    for skill_dir in "${PERSONAL_CONFIGS}/claude/skills/"*/; do
        [ -d "$skill_dir" ] || continue
        ln -sfn "${skill_dir%/}" "${USER_HOME}/.claude/skills/$(basename "$skill_dir")"
    done
    chown -R ${USERNAME}:${USERNAME} "${USER_HOME}/.claude/skills"
}

function setup_roam_notes() {
    # Provision the personal org-roam store (Syncthing-synced). Idempotent; if
    # Syncthing later populates ~/Sync/RoamNotes this just no-ops.
    mkdir -p "${USER_HOME}/Sync/RoamNotes/daily"
    [ "$DRY_RUN" = "false" ] && chown -R ${USERNAME}:${USERNAME} "${USER_HOME}/Sync/RoamNotes"
}

function setup_keyd() {
    echo "Configuring keyd key mapper..."
    if apt-cache show keyd &>/dev/null; then
        apt install keyd -y
    else
        echo "keyd package not found in repositories. Building from source..."
        # Install build dependencies
        apt install -y build-essential git
        
        # Clone and build
        local temp_dir
        temp_dir=$(mktemp -d)
        git clone --depth=1 https://github.com/rvaiya/keyd.git "$temp_dir"
        make -C "$temp_dir"
        make -C "$temp_dir" install
        rm -rf "$temp_dir"
    fi

    # Ensure /etc/keyd exists
    mkdir -p /etc/keyd

    # Copy config
    rm -f /etc/keyd/default.conf
    cp "${PERSONAL_CONFIGS}/keyd/default.conf" /etc/keyd/default.conf

    # Enable and start keyd service
    if command -v systemctl &>/dev/null; then
        if [ "$DRY_RUN" = "true" ]; then
            echo "[DRY RUN] systemctl enable --now keyd"
        else
            systemctl daemon-reload
            systemctl enable --now keyd
            systemctl restart keyd
        fi
    else
        echo "Systemd not detected. Please start keyd manually."
    fi
}




