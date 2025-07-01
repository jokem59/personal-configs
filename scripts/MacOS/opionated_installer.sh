#!/bin/bash

### Reserved for Globals
SETUP_SCRIPT_DIR=${HOME}/dev
BREW_BIN="/opt/homebrew/bin/brew"
ZSHRC_PATH=${HOME}/.zshrc
EMACS_BIN="/opt/homebrew/bin/emacs"

### Reserved for functions and imports
function setup_emacs() {
	# Install emacs
	"$BREW_BIN" tap d12frosted/emacs-plus
	"$BREW_BIN" install emacs-plus

	# Register emacs as daemon service on startup
	local emplist="/Library/LaunchAgents/emacs_server.plist"
    cat > ${emplist}<< EOF
<?xml version="1.0" encoding="UTF-8"?>
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>emacs_server</string>
    <key>ProgramArguments</key>
    <array>
      <string>/opt/homebrew/opt/emacs-plus/bin/emacs</string>
      <string>--fg-daemon</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>/tmp/emacs_server.stdout.log</string>
    <key>StandardErrorPath</key>
    <string>/tmp/emacs_server.stderr.log</string>
  </dict>
</plist>
EOF
	
	launchctl load -w ${emplist} 

	local EMACS_CONFIG_DIR="${SETUP_SCRIPT_DIR}/personal-configs/emacs/.emacs.d"
	if [ ! -d "$EMACS_CONFIG_DIR" ]; then
		echo "${FUNCNAME[0]}: Could not find source emacs configuration directory, exiting"
		exit 1
	fi

	ln -Fs "$EMACS_CONFIG_DIR" "${HOME}/.emacs.d"
}

function setup_homebrew() {
	# Install homebrew
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

	# After installation, need to do the following
	#echo >> ${ZSHRC_PATH}
	#echo 'eval "$(${BREW_BIN} shellenv)"' >> ${ZSHRC_PATH}
	#eval "$(${BREW_BIN} shellenv)"
}

function setup_macos_settings() {
	# Disable mouse pointer acceleration, requires restart to take effect
	echo "${FUNCNAME[0]}: Disabling mouse/trackpad pointer acceleration"
	defaults write -g com.apple.mouse.scaling -1
	defaults write -g com.apply.trackpad.scaling -1

	# Turn off natural scrolling
	if [ $(defaults read -g com.apple.swipescrolldirection 2>/dev/null) == "1" ]; then
		echo "${FUNCNAME[0]}: Natural scolling is ON, disabling"
		defaults write -g com.apple.swipescrolldirection -bool false
	fi
}

function setup_rectangle() {
	"$BREW_BIN" install rectangle
}

function setup_wezterm() {
	"$BREW_BIN" install wezterm
	
	local WEZTERM_CONFIG="${SETUP_SCRIPT_DIR}/personal-configs/wezterm/.wezterm.lua"
	if [ ! -e "$WEZTERM_CONFIG" ]; then
		echo "${FUNCNAME[0]}: Could not find source wezterm configuration file, exiting"
		exit 1 
	fi

	ln -sf "$WEZTERM_CONFIG" "${HOME}/.wezterm.lua"	
}

function setup_fonts() {
	"$BREW_BIN" install --cask font-roboto-mono 
}

function setup_karabiner() {
	"$BREW_BIN" install --cask karabiner-elements

	local KARABINER_CONFIG="${SETUP_SCRIPT_DIR}/personal-configs/karabiner"
	if [ ! -d "$KARABINER_CONFIG" ]; then
		echo "${FUNCNAME[0]}: Could not find source karabiner configuration file, exiting"
		exit 1
	fi

	ln -Fs "$KARABINER_CONFIG" "${HOME}/.config/karabiner"
}

function setup_helix() {
	"$BREW_BIN" install helix

	local HX_CONFIG_DIR="${SETUP_SCRIPT_DIR}/personal-configs/helix"
	if [ ! -d "$HX_CONFIG_DIR" ]; then
		echo "${FUNCNAME[0]}: Could not find source helix configuration dir, exiting"
		exit 1
	fi

	ln -sF "$HX_CONFIG_DIR" "${HOME}/.config/helix"
}

function setup_zsh() {
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	"$BREW_BIN" install zsh-autosuggestions

	local ZSHRC_CONFIG="${SETUP_SCRIPT_DIR}/personal-configs/zsh/.zshrc"
	if [ ! -e "$ZSHRC_CONFIG" ]; then
		echo "${FUNCNAME[0]}: Could not find source .zshrc configuration, exiting"
		exit 1
	fi

	ln -sf "$ZSHRC_CONFIG" "${HOME}/.zshrc" 
}

### Main
# TODO: Optional to install karabiner since it uses custom keybindings others might not want
# TODO: Optionally take in path to setup scripts
function main() {
	mkdir "${HOME}/.config"

	setup_macos_settings

	# Installs basic tools such as git, gcc, the works
	xcode-select --install

	# Assumes setups scripts go into ~/dev, allow this to be overridden
	if [ ! -d "$SETUP_SCRIPT_DIR" ]; then
		mkdir "$SETUP_SCRIPT_DIR"
	fi

	pushd "$SETUP_SCRIPT_DIR"
	# TODO: replace with variable
	git clone https://github.com/jokem59/personal-configs.git 
	popd

	# Setup zshrc, oh-my-zsh, zsh-autocomplete, link zshrc in
	if [ ! -e "${HOME}/.oh-my-zsh" ]; then
		setup_zsh
	fi

	if [ ! -e "$BREW_BIN" ]; then
		setup_homebrew
	fi

	if [ ! -e "$EMACS_BIN" ]; then
		setup_emacs
	fi

	if [ ! -e "/opt/homebrew/Caskroom/rectangle" ]; then
		setup_rectangle
	fi

	# Setup Wezterm
	if [ ! -e "/opt/homebrew/bin/wezterm" ]; then
		setup_wezterm
	fi

	setup_fonts
	setup_karabiner

	# Setup syncthing; something for later

	# Setup helix
	if [ ! -e "/opt/homebrew/bin/hx" ]; then
		setup_helix
	fi
}

main
