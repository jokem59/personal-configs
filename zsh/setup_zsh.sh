#!/bin/bash

# Abort on non-zero exit status, abort on unbound variable, don't hide errors in pipes
set -euo pipefail

function setup_zsh() {
    apt install zsh -y

    # Use zsh by default, requires user to logout/login
    chsh -s $(which zsh)

    # Install oh-my-zsh
    wget -P ~ https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
    chmod +x ~/install.sh
    ~/install.sh

    # Install zsh-syntax-highlighting
    local zsh_dir='/usr/share/zsh-syntax-highlighting'
    mkdir ${zsh_dir}
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${zsh_dir}

    # Install powerlevel10k
    local pl10_dir='/usr/share/powerlevel10k'
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${pl10_dir}

    # Link .zshrc
    rm ~/.zshrc || true
    ln -s ~/dev/personal-configs/zsh/.zshrc ~/.zshrc
}

setup_zsh
