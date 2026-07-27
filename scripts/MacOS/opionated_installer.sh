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
	# Install homebrew (non-interactive: skips the "Press RETURN" prompt)
	if ! command -v brew &>/dev/null; then
		NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
		eval "$(${BREW_BIN} shellenv)"
	fi
	# Suppress cleanup/env hints for the rest of the run
	export HOMEBREW_NO_INSTALL_CLEANUP=1
	export HOMEBREW_NO_ENV_HINTS=1
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

	# Faster key repeat than the System Settings slider allows (1 = fastest
	# repeat, 10 = short initial delay), and disable the press-and-hold accent
	# popup so holding a key repeats it instead. Both requested by default in
	# most Cocoa text views; without this, held movement keys (C-n/C-v/etc in
	# Emacs and others) feel choppy. Requires restarting apps (or logging out)
	# to take full effect everywhere.
	echo "${FUNCNAME[0]}: Setting faster key repeat rate and disabling press-and-hold"
	defaults write -g KeyRepeat -int 1
	defaults write -g InitialKeyRepeat -int 10
	defaults write -g ApplePressAndHoldEnabled -bool false
}

function setup_scroll_reverser() {
	"$BREW_BIN" install --cask scroll-reverser

	# Reverse trackpad scrolling on both axes, mouse left un-reversed.
	# Scroll Reverser predates per-axis support: the vertical axis is tied to
	# the original InvertScrollingOn toggle, horizontal is the separate
	# ReverseX opt-in added later.
	defaults write com.pilotmoon.scroll-reverser InvertScrollingOn -bool true
	defaults write com.pilotmoon.scroll-reverser ReverseX -bool true
	defaults write com.pilotmoon.scroll-reverser ReverseMouse -bool false

	# Restart so the new prefs take effect
	killall "Scroll Reverser" 2>/dev/null || true
	open -a "Scroll Reverser"

	echo "${FUNCNAME[0]}: NOTE macOS will prompt for Accessibility/Input Monitoring permission on first launch; this can't be granted non-interactively"
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

function setup_emacs() {
	"$BREW_BIN" tap d12frosted/emacs-plus
	# Homebrew >= 6.0 blocks loading formulae from third-party taps until trusted.
	# Older Homebrew has no `trust` subcommand, so tolerate its absence/failure.
	"$BREW_BIN" trust --tap d12frosted/emacs-plus 2>/dev/null || true
	"$BREW_BIN" install emacs-plus

	# Symlink the .app bundle into /Applications so it shows in Launchpad/Spotlight
	# and can be dragged onto the Dock (brew doesn't do this for formulae)
	local EMACS_APP_DIR
	EMACS_APP_DIR="$("$BREW_BIN" --prefix emacs-plus)/Emacs.app"
	if [ -d "$EMACS_APP_DIR" ]; then
		rm -rf "/Applications/Emacs.app" 2>/dev/null || true
		ln -sf "$EMACS_APP_DIR" "/Applications/Emacs.app"
	fi

	local EMACS_CONFIG_DIR="${PERSONAL_CONFIGS}/emacs/.emacs.d"
	if [ ! -d "$EMACS_CONFIG_DIR" ]; then
		echo "${FUNCNAME[0]}: Could not find source emacs configuration dir, exiting"
		exit 1
	fi

	rm -rf "${HOME}/.emacs.d" 2>/dev/null || true
	ln -sf "$EMACS_CONFIG_DIR" "${HOME}/.emacs.d"

	# Install the all-the-icons glyph fonts. Without them, icons in Emacs
	# completion UIs (vertico + marginalia + all-the-icons-completion, used by
	# find-file etc.) render as blank/missing glyphs.
	local EMACS_BIN
	EMACS_BIN="$("$BREW_BIN" --prefix emacs-plus)/bin/emacs"
	if [ ! -f "${HOME}/Library/Fonts/all-the-icons.ttf" ]; then
		"$EMACS_BIN" --batch \
			--eval "(require 'package)" \
			--eval "(add-to-list 'package-archives '(\"melpa\" . \"https://melpa.org/packages/\") t)" \
			--eval "(package-initialize)" \
			--eval "(unless (package-installed-p 'all-the-icons) (package-refresh-contents) (package-install 'all-the-icons))" \
			--eval "(require 'all-the-icons)" \
			--eval "(all-the-icons-install-fonts t)"
	fi

	# Register emacs daemon as a per-user LaunchAgent (avoids requiring sudo)
	mkdir -p "${HOME}/Library/LaunchAgents"
	rm -f "${HOME}/Library/LaunchAgents/emacs_server.plist"
	ln -sf "${PERSONAL_CONFIGS}/scripts/MacOS/emacs_server.plist" "${HOME}/Library/LaunchAgents/emacs_server.plist"
	launchctl unload "${HOME}/Library/LaunchAgents/emacs_server.plist" 2>/dev/null || true
	launchctl load -w "${HOME}/Library/LaunchAgents/emacs_server.plist"
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

	# Build tmux-thumbs if it was cloned but cargo wasn't available at the time
	if [ -d "${HOME}/dev/tmux-thumbs" ] && ! [ -f "${HOME}/dev/tmux-thumbs/target/release/tmux-thumbs" ]; then
		(cd "${HOME}/dev/tmux-thumbs" && cargo build --release)
	fi
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
	"$BREW_BIN" install tmux fzf

	rm -f "${HOME}/.tmux.conf"
	git clone https://github.com/gpakosz/.tmux.git "${HOME}/.local/share/tmux/oh-my-tmux" 2>/dev/null || (cd "${HOME}/.local/share/tmux/oh-my-tmux" && git pull)
	mkdir -p "${HOME}/.config/tmux"
	ln -sf "${HOME}/.local/share/tmux/oh-my-tmux/.tmux.conf" "${HOME}/.config/tmux/tmux.conf"
	ln -sf "${PERSONAL_CONFIGS}/tmux/.tmux.conf.local" "${HOME}/.config/tmux/tmux.conf.local"

	# tmux plugins
	mkdir -p "${HOME}/dev"
	git clone https://github.com/tmux-plugins/tmux-resurrect "${HOME}/dev/tmux-resurrect" 2>/dev/null || (cd "${HOME}/dev/tmux-resurrect" && git pull)
	git clone https://github.com/tmux-plugins/tmux-continuum "${HOME}/dev/tmux-continuum" 2>/dev/null || (cd "${HOME}/dev/tmux-continuum" && git pull)
	git clone https://github.com/fcsonline/tmux-thumbs "${HOME}/dev/tmux-thumbs" 2>/dev/null || (cd "${HOME}/dev/tmux-thumbs" && git pull)

	# We need rust/cargo to build tmux-thumbs. If not installed, we can run setup_rust
	if ! command -v cargo &>/dev/null; then
		echo "Cargo not found. Installing Rust first to build tmux-thumbs..."
		setup_rust
	fi

	echo "Building tmux-thumbs..."
	(cd "${HOME}/dev/tmux-thumbs" && cargo build --release)
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

	if ! xcode-select -p &>/dev/null; then
		xcode-select --install
		# Block until the CLT install completes (GUI installer runs async)
		until xcode-select -p &>/dev/null; do
			sleep 5
		done
	fi

	setup_homebrew

	if [ ! -e "$ZSHRC_PATH" ] || [ ! -d "${HOME}/.oh-my-zsh" ]; then
		setup_zsh
	fi

	setup_bash
	setup_vim
	setup_tmux

	if [ ! -d "/opt/homebrew/opt/emacs-plus" ]; then
		setup_emacs
	fi

	if [ ! -e "/opt/homebrew/Caskroom/rectangle" ]; then
		setup_rectangle
	fi

	if [ ! -e "/Applications/Alacritty.app" ]; then
		setup_alacritty
	fi

	setup_fonts
	setup_karabiner
	setup_scroll_reverser
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
