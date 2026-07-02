#!/bin/bash

### Dynamic Pathing & Globals
if [ -z "${PERSONAL_CONFIGS:-}" ]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    PERSONAL_CONFIGS="$(cd "${SCRIPT_DIR}/../.." && pwd)"
fi

BREW_BIN="/opt/homebrew/bin/brew"
ZSHRC_PATH=${HOME}/.zshrc

### Functions

function setup_homebrew() {
	# Install homebrew
	if ! command -v brew &>/dev/null; then
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
		eval "$(${BREW_BIN} shellenv)"
	fi
}

function setup_macos_settings() {
	# Disable mouse pointer acceleration, requires restart to take effect
	echo "${FUNCNAME[0]}: Disabling mouse/trackpad pointer acceleration"
	defaults write -g com.apple.mouse.scaling -1 2>/dev/null || true
	defaults write -g com.apple.trackpad.scaling -1 2>/dev/null || true

	# Turn off natural scrolling
	if [ "$(defaults read -g com.apple.swipescrolldirection 2>/dev/null)" == "1" ]; then
		echo "${FUNCNAME[0]}: Natural scrolling is ON, disabling"
		defaults write -g com.apple.swipescrolldirection -bool false
	fi
}

function setup_rectangle() {
	"$BREW_BIN" install --cask rectangle
}

function setup_alacritty() {
	"$BREW_BIN" install --cask alacritty
	
	local ALACRITTY_CONFIG_DIR="${PERSONAL_CONFIGS}/alacritty"
	if [ ! -d "$ALACRITTY_CONFIG_DIR" ]; then
		echo "${FUNCNAME[0]}: Could not find source alacritty configuration dir, exiting"
		exit 1 
	fi

	mkdir -p "${HOME}/.config/alacritty"
	rm "${HOME}/.config/alacritty/alacritty.toml" 2>/dev/null || true
	ln -sf "$ALACRITTY_CONFIG_DIR/alacritty.toml" "${HOME}/.config/alacritty/alacritty.toml"

	if [ -d "$ALACRITTY_CONFIG_DIR/themes" ]; then
		rm -rf "${HOME}/.config/alacritty/themes" 2>/dev/null || true
		ln -sf "$ALACRITTY_CONFIG_DIR/themes" "${HOME}/.config/alacritty/themes"
	fi

	if [ -d "$ALACRITTY_CONFIG_DIR/themes-pack" ]; then
		rm -rf "${HOME}/.config/alacritty/themes-pack" 2>/dev/null || true
		ln -sf "$ALACRITTY_CONFIG_DIR/themes-pack" "${HOME}/.config/alacritty/themes-pack"
	fi
}

function setup_fonts() {
	"$BREW_BIN" install --cask font-roboto-mono
}

function setup_karabiner() {
	"$BREW_BIN" install --cask karabiner-elements

	local KARABINER_CONFIG="${PERSONAL_CONFIGS}/karabiner"
	if [ ! -d "$KARABINER_CONFIG" ]; then
		echo "${FUNCNAME[0]}: Could not find source karabiner configuration file, exiting"
		exit 1
	fi

	mkdir -p "${HOME}/.config"
	rm -rf "${HOME}/.config/karabiner" 2>/dev/null || true
	ln -sF "$KARABINER_CONFIG" "${HOME}/.config/karabiner"
}

function setup_helix() {
	"$BREW_BIN" install helix

	local HX_CONFIG_DIR="${PERSONAL_CONFIGS}/helix"
	if [ ! -d "$HX_CONFIG_DIR" ]; then
		echo "${FUNCNAME[0]}: Could not find source helix configuration dir, exiting"
		exit 1
	fi

	mkdir -p "${HOME}/.config"
	rm -rf "${HOME}/.config/helix" 2>/dev/null || true
	ln -sF "$HX_CONFIG_DIR" "${HOME}/.config/helix"
}

function setup_zsh() {
	if [ ! -d "${HOME}/.oh-my-zsh" ]; then
		sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
	fi
	"$BREW_BIN" install zsh-autosuggestions zsh-syntax-highlighting

	local ZSHRC_CONFIG="${PERSONAL_CONFIGS}/zsh/.zshrc"
	if [ ! -e "$ZSHRC_CONFIG" ]; then
		echo "${FUNCNAME[0]}: Could not find source .zshrc configuration, exiting"
		exit 1
	fi

	rm "${HOME}/.zshrc" 2>/dev/null || true
	ln -sf "$ZSHRC_CONFIG" "${HOME}/.zshrc" 
}

function setup_bash() {
	local BASHRC_CONFIG="${PERSONAL_CONFIGS}/bash/.bashrc"
	if [ ! -e "$BASHRC_CONFIG" ]; then
		echo "${FUNCNAME[0]}: Could not find source .bashrc configuration, exiting"
		exit 1
	fi

	rm "${HOME}/.bashrc" 2>/dev/null || true
	ln -sf "$BASHRC_CONFIG" "${HOME}/.bashrc"

	if [ ! -d "${HOME}/.bash-git-prompt" ]; then
		git clone https://github.com/magicmonty/bash-git-prompt.git "${HOME}/.bash-git-prompt" --depth=1
	fi
}

function setup_syncthing() {
	"$BREW_BIN" install syncthing
	"$BREW_BIN" services start syncthing 2>/dev/null || true
}

function setup_rust() {
	if ! command -v rustup &>/dev/null; then
		curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
		source "${HOME}/.cargo/env"
	fi
	rustup component add rust-src
	cargo install rust-analyzer 2>/dev/null || true
}

function setup_gitu() {
	"$BREW_BIN" install gitu
}

function setup_vim() {
	"$BREW_BIN" install vim
	rm "${HOME}/.vimrc" 2>/dev/null || true
	ln -sf "${PERSONAL_CONFIGS}/vim/.vimrc" "${HOME}/.vimrc"
}

function setup_tmux() {
	"$BREW_BIN" install tmux
	rm -f "${HOME}/.tmux.conf"
	ln -sf "${PERSONAL_CONFIGS}/tmux/.tmux.conf" "${HOME}/.tmux.conf"
}

function setup_mo() {
	# Support standard Apple App Support path
	mkdir -p "${HOME}/Library/Application Support/mo"
	rm -f "${HOME}/Library/Application Support/mo/config.toml"
	ln -sf "${PERSONAL_CONFIGS}/mo/config.toml" "${HOME}/Library/Application Support/mo/config.toml"

	# Support XDG fallback path
	mkdir -p "${HOME}/.config/mo"
	rm -f "${HOME}/.config/mo/config.toml"
	ln -sf "${PERSONAL_CONFIGS}/mo/config.toml" "${HOME}/.config/mo/config.toml"
}

### Main Wrapper
function main() {
	mkdir -p "${HOME}/.config"

	setup_macos_settings

	if [ ! -d "/Library/Developer/CommandLineTools" ]; then
		xcode-select --install
	fi

	setup_homebrew

	if [ ! -e "$ZSHRC_PATH" ] || [ ! -d "${HOME}/.oh-my-zsh" ]; then
		setup_zsh
	fi

	setup_bash
	setup_vim
	setup_tmux

	if [ ! -e "/opt/homebrew/Caskroom/rectangle" ]; then
		setup_rectangle
	fi

	if [ ! -e "/Applications/Alacritty.app" ]; then
		setup_alacritty
	fi

	setup_fonts
	setup_karabiner
	setup_syncthing
	setup_rust
	setup_gitu
	setup_mo

	if [ ! -e "/opt/homebrew/bin/hx" ]; then
		setup_helix
	fi
}

if [ -z "${MAC_SETUP_NO_RUN:-}" ]; then
	main
fi
