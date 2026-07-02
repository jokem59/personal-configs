#!/bin/bash

# Abort on error, unbound variables
set -euo pipefail

# Parse command line arguments
DRY_RUN=false
for arg in "$@"; do
    case $arg in
        -d|--dry-run)
            DRY_RUN=true
            ;;
    esac
done

# Dynamic Pathing
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Resolve SUDO user details for permission safety
SUDO_USER_HOME=""
if [ -n "${SUDO_USER:-}" ]; then
    SUDO_USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6 || echo "")
fi
USER_HOME="${SUDO_USER_HOME:-$HOME}"
USERNAME="${SUDO_USER:-$USER}"

# Backup utility
backup_file() {
    local file="$1"
    if [ -f "$file" ] || [ -d "$file" ]; then
        local backup="${file}.backup.$(date +%Y%m%d%H%M%S)"
        if [ "$DRY_RUN" = "true" ]; then
            echo "[DRY RUN] Would backup $file to $backup"
        else
            echo "Backing up $file to $backup"
            mv "$file" "$backup"
        fi
    fi
}

# Idempotent and Dry-run Wrapper Functions
apt() {
    run_apt_with_repair() {
        if ! command apt "$@"; then
            # If the command failed, check if we can run dpkg --configure -a
            echo "Warning: apt command failed. Attempting to repair dpkg database via 'dpkg --configure -a'..."
            if dpkg --configure -a; then
                echo "Repaired dpkg database. Retrying apt command..."
                command apt "$@"
            else
                echo "Error: Failed to repair dpkg database. Please run 'sudo dpkg --configure -a' manually."
                return 1
            fi
        fi
    }

    if [ "$1" = "install" ]; then
        shift
        local pkgs_to_install=()
        local force_yes=false
        for arg in "$@"; do
            if [ "$arg" = "-y" ] || [ "$arg" = "--yes" ]; then
                force_yes=true
            elif [[ "$arg" =~ ^- ]]; then
                # Skip flags
                :
            else
                # Check if package is already installed
                if dpkg -s "$arg" &>/dev/null; then
                    echo "Package $arg is already installed. Skipping."
                else
                    pkgs_to_install+=("$arg")
                fi
            fi
        done
        
        if [ ${#pkgs_to_install[@]} -eq 0 ]; then
            return 0
        fi
        
        if [ "$DRY_RUN" = "true" ]; then
            echo "[DRY RUN] apt install ${pkgs_to_install[*]}"
        else
            local apt_args=()
            if [ "$force_yes" = "true" ]; then apt_args+=("-y"); fi
            apt_args+=("install")
            apt_args+=("${pkgs_to_install[@]}")
            run_apt_with_repair "${apt_args[@]}"
        fi
    elif [ "$1" = "update" ]; then
        if [ "$DRY_RUN" = "true" ]; then
            echo "[DRY RUN] apt update"
        else
            run_apt_with_repair update -y
        fi
    else
        if [ "$DRY_RUN" = "true" ]; then
            echo "[DRY RUN] apt $*"
        else
            run_apt_with_repair "$@"
        fi
    fi
}


apt-get() {
    apt "$@"
}

add-apt-repository() {
    if [ "$DRY_RUN" = "true" ]; then
        echo "[DRY RUN] add-apt-repository $*"
    else
        command add-apt-repository "$@"
    fi
}

brew() {
    if [ "$1" = "install" ]; then
        shift
        local pkgs_to_install=()
        local cask=false
        for arg in "$@"; do
            if [ "$arg" = "--cask" ]; then
                cask=true
            elif [[ "$arg" =~ ^- ]]; then
                :
            else
                local check_cmd="command brew list $arg"
                [ "$cask" = "true" ] && check_cmd="command brew list --cask $arg"
                if $check_cmd &>/dev/null; then
                    echo "Brew package $arg is already installed. Skipping."
                else
                    pkgs_to_install+=("$arg")
                fi
            fi
        done
        
        if [ ${#pkgs_to_install[@]} -eq 0 ]; then
            return 0
        fi
        
        if [ "$DRY_RUN" = "true" ]; then
            local cask_flag=""
            [ "$cask" = "true" ] && cask_flag="--cask "
            echo "[DRY RUN] brew install ${cask_flag}${pkgs_to_install[*]}"
        else
            local cask_flag=""
            [ "$cask" = "true" ] && cask_flag="--cask"
            command brew install $cask_flag "${pkgs_to_install[@]}"
        fi
    else
        if [ "$DRY_RUN" = "true" ]; then
            echo "[DRY RUN] brew $*"
        else
            command brew "$@"
        fi
    fi
}

ln() {
    local symbolic=false
    local force=false
    local target=""
    local link_name=""
    local args=()
    
    for arg in "$@"; do
        if [[ "$arg" =~ ^- ]]; then
            if [[ "$arg" == *s* ]]; then symbolic=true; fi
            if [[ "$arg" == *f* ]]; then force=true; fi
        else
            args+=("$arg")
        fi
    done
    
    if [ ${#args[@]} -ge 2 ]; then
        target="${args[0]}"
        link_name="${args[1]}"
        
        if [ "$symbolic" = "true" ] && [ -L "$link_name" ] && [ "$(readlink "$link_name")" = "$target" ]; then
            echo "Symbolic link $link_name already points to $target. Skipping."
            return 0
        fi
    fi
    
    if [ "$DRY_RUN" = "true" ]; then
        echo "[DRY RUN] ln $*"
    else
        # Perform link creation with standard ln
        # If target link name exists and is not pointing to target, we let ln recreate it
        command ln "$@"
    fi
}

# Dry-run only mocks (active only if DRY_RUN is true)
if [ "$DRY_RUN" = "true" ]; then
    echo "========================================================="
    echo "  DRY-RUN MODE ACTIVATED: No system changes will be made "
    echo "========================================================="
    
    git() { echo "[DRY RUN] git $*"; }
    cargo() { echo "[DRY RUN] cargo $*"; }
    defaults() {
        if [ "$1" = "write" ]; then
            echo "[DRY RUN] defaults $*"
        else
            command defaults "$@"
        fi
    }
    launchctl() { echo "[DRY RUN] launchctl $*"; }
    xcode-select() { echo "[DRY RUN] xcode-select $*"; }
    chown() { echo "[DRY RUN] chown $*"; }
    usermod() { echo "[DRY RUN] usermod $*"; }
    rm() { echo "[DRY RUN] rm $*"; }
    mkdir() { echo "[DRY RUN] mkdir $*"; }
    dconf() { echo "[DRY RUN] dconf $*"; }
    systemctl() { echo "[DRY RUN] systemctl $*"; }
    make() { echo "[DRY RUN] make $*"; }
    patch() { echo "[DRY RUN] patch $*"; }
    
    tee() {
        echo "[DRY RUN] tee $*"
        cat >/dev/null
    }
    apt-key() {
        echo "[DRY RUN] apt-key $*"
        cat >/dev/null
    }
    
    curl() {
        if [[ "$*" == *"/sh.rustup.rs"* ]] || [[ "$*" == *"/install.sh"* ]]; then
            echo "[DRY RUN] curl $* (Installation download bypassed)"
        else
            command curl "$@"
        fi
    }
    wget() {
        echo "[DRY RUN] wget $*"
    }
    sh() {
        echo "[DRY RUN] sh $* (Bypassed execution of piped script)"
        cat >/dev/null
    }
fi

# Determine OS
OS="$(uname -s)"

# Load platform utilities
if [ "$OS" = "Linux" ]; then
    export PERSONAL_CONFIGS="$REPO_ROOT"
    source "${REPO_ROOT}/scripts/Linux/SetupFunctions.sh"
elif [ "$OS" = "Darwin" ]; then
    export PERSONAL_CONFIGS="$REPO_ROOT"
    export MAC_SETUP_NO_RUN=1
    source "${REPO_ROOT}/scripts/MacOS/opionated_installer.sh"
else
    echo "Unsupported OS: $OS. If you are on Windows, please run setup.ps1 in PowerShell."
    exit 1
fi

# Auto-repair empty Alacritty PPA GPG key on startup if it was left incomplete
if [ "$OS" = "Linux" ] && [ -f "/etc/apt/sources.list.d/aslatter-ppa.list" ]; then
    if [ ! -f "/etc/apt/trusted.gpg.d/aslatter-ppa.gpg" ] || [ ! -s "/etc/apt/trusted.gpg.d/aslatter-ppa.gpg" ]; then
        echo "Detected missing or empty Alacritty PPA GPG key on startup. Repairing..."
        if [ "$DRY_RUN" = "true" ]; then
            echo "[DRY RUN] Would repair Alacritty PPA GPG key"
        else
            curl -s "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x52B24DF7D43B5377" | gpg --homedir /tmp --dearmor | tee /etc/apt/trusted.gpg.d/aslatter-ppa.gpg >/dev/null
        fi
    fi
fi

function setup_system_packages() {
    echo "Installing standard utility packages via apt..."
    apt update
    
    # Determine correct locate package based on repository availability
    local locate_pkg="plocate"
    if ! apt-cache show plocate &>/dev/null; then
        locate_pkg="mlocate"
    fi
    
    apt install -y curl wget xclip tmux gnome-tweaks ripgrep shellcheck htop hwloc dconf-cli blueman gnome-clocks imagemagick "$locate_pkg"
}

function setup_bash_linux() {
    echo "Setting up Bash on Linux..."
    backup_file "${USER_HOME}/.bashrc"
    ln -sf "${REPO_ROOT}/bash/.bashrc" "${USER_HOME}/.bashrc"
    [ "$DRY_RUN" = "false" ] && chown ${USERNAME}:${USERNAME} "${USER_HOME}/.bashrc"

    # Clone bash-git-prompt
    if [ ! -d "${USER_HOME}/.bash-git-prompt" ]; then
        echo "Cloning bash-git-prompt..."
        if [ "$DRY_RUN" = "true" ]; then
            echo "[DRY RUN] Would clone bash-git-prompt to ${USER_HOME}/.bash-git-prompt"
        else
            sudo -u ${USERNAME} -i git clone https://github.com/magicmonty/bash-git-prompt.git "${USER_HOME}/.bash-git-prompt" --depth=1
        fi
    fi

    # Set case-insensitive completion
    if grep -qi completion-ignore-case /etc/inputrc 2>/dev/null; then
        echo "completion-ignore-case already set to On in /etc/inputrc"
    else
        echo "set completion-ignore-case On" | tee -a /etc/inputrc >/dev/null
    fi
}

function setup_zsh_linux() {
    echo "Setting up Zsh on Linux..."
    apt install -y zsh

    # Change default shell
    local user_shell
    user_shell=$(getent passwd "${USERNAME}" | cut -d: -f7)
    local zsh_path
    zsh_path=$(which zsh)
    if [ "$user_shell" != "$zsh_path" ]; then
        echo "Changing default shell to zsh for user ${USERNAME}..."
        usermod -s "$zsh_path" "${USERNAME}"
    fi

    # Install oh-my-zsh for the user
    if [ ! -d "${USER_HOME}/.oh-my-zsh" ]; then
        echo "Installing Oh-My-Zsh..."
        if [ "$DRY_RUN" = "true" ]; then
            echo "[DRY RUN] Would install Oh-My-Zsh for user ${USERNAME}"
        else
            sudo -u "${USERNAME}" -i sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        fi
    fi

    # Install plugins
    local zsh_sh_dir="/usr/share/zsh-syntax-highlighting"
    if [ ! -d "$zsh_sh_dir" ]; then
        mkdir -p "$zsh_sh_dir"
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$zsh_sh_dir"
    fi

    local zsh_as_dir="/usr/share/zsh-autosuggestions"
    if [ ! -d "$zsh_as_dir" ]; then
        mkdir -p "$zsh_as_dir"
        git clone https://github.com/zsh-users/zsh-autosuggestions.git "$zsh_as_dir"
    fi

    local p10k_dir="/usr/share/powerlevel10k"
    if [ ! -d "$p10k_dir" ]; then
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$p10k_dir"
    fi

    # Link .zshrc
    backup_file "${USER_HOME}/.zshrc"
    ln -sf "${REPO_ROOT}/zsh/.zshrc" "${USER_HOME}/.zshrc"
    [ "$DRY_RUN" = "false" ] && chown "${USERNAME}:${USERNAME}" "${USER_HOME}/.zshrc"
}

run_full_setup() {
    echo "Starting full developer environment setup..."
    if [ "$OS" = "Linux" ]; then
        if [ "$DRY_RUN" = "false" ] && ! [ "$(id -u)" = 0 ]; then
            echo "Apt packages require root. Please re-run: sudo ./setup.sh"
            exit 1
        fi
        setup_system_packages
        setup_bash_linux
        setup_zsh_linux
        setup_vim
        setup_tmux
        setup_helix
        setup_alacritty
        setup_syncthing
        setup_rust
        setup_gitu
        setup_mo
        get_latex_packages
        setup_gnome_terminal
        setup_gnome_settings
    elif [ "$OS" = "Darwin" ]; then
        if [ "$DRY_RUN" = "false" ] && [ "$(id -u)" = 0 ]; then
            echo "Error: Do not run macOS installer as root/sudo. Homebrew forbids root installation."
            echo "Run as your normal user: ./setup.sh"
            exit 1
        fi
        setup_macos_settings
        if [ ! -d "/Library/Developer/CommandLineTools" ]; then
            xcode-select --install
        fi
        setup_homebrew
        setup_zsh
        setup_bash
        setup_vim
        setup_tmux
        setup_helix
        setup_alacritty
        setup_rectangle
        setup_fonts
        setup_karabiner
        setup_syncthing
        setup_rust
        setup_gitu
        setup_mo
    fi
    echo "Full Setup completed successfully!"
}

run_shell_setup() {
    echo "Starting shell configuration setup..."
    if [ "$OS" = "Linux" ]; then
        if [ "$DRY_RUN" = "false" ] && ! [ "$(id -u)" = 0 ]; then
            echo "Shell setup requires root rights for package installs. Please re-run: sudo ./setup.sh"
            exit 1
        fi
        setup_bash_linux
        setup_zsh_linux
        setup_vim
        setup_tmux
    elif [ "$OS" = "Darwin" ]; then
        if [ "$DRY_RUN" = "false" ] && [ "$(id -u)" = 0 ]; then
            echo "Please run as normal user (not root)."
            exit 1
        fi
        setup_homebrew
        setup_zsh
        setup_bash
        setup_vim
        setup_tmux
    fi
    echo "Shell configuration setup completed!"
}

run_selective_setup() {
    echo "--- Selective Component Setup ---"
    if [ "$OS" = "Linux" ]; then
        if [ "$DRY_RUN" = "false" ] && ! [ "$(id -u)" = 0 ]; then
            echo "Selective setup on Linux requires root. Please run: sudo ./setup.sh"
            exit 1
        fi
        
        ask_install() {
            local name="$1"
            read -p "Install/Configure $name? [y/N]: " yn
            case $yn in
                [Yy]*) return 0 ;;
                *) return 1 ;;
            esac
        }

        if ask_install "System Utility Packages (ripgrep, htop, xclip, imagemagick)"; then setup_system_packages; fi
        if ask_install "Bash configuration and prompt"; then setup_bash_linux; fi
        if ask_install "Zsh shell & Oh-My-Zsh"; then setup_zsh_linux; fi
        if ask_install "Vim editor configuration"; then setup_vim; fi
        if ask_install "Tmux terminal multiplexer"; then setup_tmux; fi
        if ask_install "Helix editor configuration"; then setup_helix; fi
        if ask_install "Alacritty terminal emulator"; then setup_alacritty; fi
        if ask_install "Syncthing background replication"; then setup_syncthing; fi
        if ask_install "Rust programming language and components"; then setup_rust; fi
        if ask_install "gitu Git TUI"; then setup_gitu; fi
        if ask_install "mo note-taking config"; then setup_mo; fi
        if ask_install "LaTeX complete package suite (Large download)"; then get_latex_packages; fi
        if ask_install "GNOME desktop tweaks and custom font imports"; then setup_gnome_terminal; setup_gnome_settings; fi
        
    elif [ "$OS" = "Darwin" ]; then
        if [ "$DRY_RUN" = "false" ] && [ "$(id -u)" = 0 ]; then
            echo "Run as normal user (not root)."
            exit 1
        fi
        
        setup_homebrew
        
        ask_install() {
            local name="$1"
            read -p "Install/Configure $name? [y/N]: " yn
            case $yn in
                [Yy]*) return 0 ;;
                *) return 1 ;;
            esac
        }

        if ask_install "macOS mouse/scrolling settings"; then setup_macos_settings; fi
        if ask_install "Zsh shell & Oh-My-Zsh"; then setup_zsh; fi
        if ask_install "Bash configuration and prompt"; then setup_bash; fi
        if ask_install "Vim editor configuration"; then setup_vim; fi
        if ask_install "Tmux terminal multiplexer"; then setup_tmux; fi
        if ask_install "Helix editor configuration"; then setup_helix; fi
        if ask_install "Alacritty terminal emulator"; then setup_alacritty; fi
        if ask_install "Rectangle window manager"; then setup_rectangle; fi
        if ask_install "Roboto Mono custom fonts"; then setup_fonts; fi
        if ask_install "Karabiner-elements for PC keys"; then setup_karabiner; fi
        if ask_install "Syncthing replication service"; then setup_syncthing; fi
        if ask_install "Rust & cargo tools"; then setup_rust; fi
        if ask_install "gitu Git TUI"; then setup_gitu; fi
        if ask_install "mo note-taking config"; then setup_mo; fi
    fi
    echo "Selective component setup completed!"
}

show_menu() {
    echo "========================================="
    echo "  Unified personal-configs Installer     "
    echo "========================================="
    echo "Detected platform: $OS"
    echo "Target User: $USERNAME"
    echo "Repository Path: $REPO_ROOT"
    echo "Dry-Run Mode: $([ "$DRY_RUN" = "true" ] && echo "ENABLED" || echo "DISABLED")"
    echo "-----------------------------------------"
    echo "1) Full Developer Environment (All tools)"
    echo "2) Shell Configs Only (Bash, Zsh, Vim)"
    echo "3) Selective Component Setup (Custom)"
    echo "4) Toggle Dry-Run Mode"
    echo "5) Exit"
    echo "========================================="
    read -p "Please select an option [1-5]: " choice
    case $choice in
        1) run_full_setup ;;
        2) run_shell_setup ;;
        3) run_selective_setup ;;
        4) 
            if [ "$DRY_RUN" = "true" ]; then
                echo "Please restart script without -d/--dry-run to run with changes disabled."
                DRY_RUN=false
                # Reload standard functions
                unset -f apt apt-get add-apt-repository brew ln git cargo defaults launchctl xcode-select chown usermod rm mkdir dconf systemctl make patch tee apt-key curl wget sh backup_file
                backup_file() {
                    local file="$1"
                    if [ -f "$file" ] || [ -d "$file" ]; then
                        local backup="${file}.backup.$(date +%Y%m%d%H%M%S)"
                        echo "Backing up $file to $backup"
                        mv "$file" "$backup"
                    fi
                }
            else
                echo "Restarting script in dry-run mode..."
                exec "$0" --dry-run
            fi
            show_menu
            ;;
        5) exit 0 ;;
        *) echo "Invalid option"; show_menu ;;
    esac
}

show_menu
