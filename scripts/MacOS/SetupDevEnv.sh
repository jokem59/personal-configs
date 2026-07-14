#!/usr/bin/env bash
#
# macOS dev environment setup.
#
# Usage:
#   ./SetupDevEnv.sh            # run everything (in order)
#   ./SetupDevEnv.sh tmux       # run a single component
#   ./SetupDevEnv.sh tmux helix # run several components
#   ./SetupDevEnv.sh --list     # list available components

setup_prereqs() {
  # Install Xcode Command Line Tools (git, clang, etc.)
  if ! xcode-select -p >/dev/null 2>&1; then
    xcode-select --install
    # Block until the CLT install completes (GUI installer runs async)
    until xcode-select -p >/dev/null 2>&1; do
      sleep 5
    done
  fi

  # Install HomeBrew (non-interactive: skips the "Press RETURN" prompt)
  if ! command -v brew >/dev/null 2>&1; then
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
}

setup_emacs() {
  brew tap d12frosted/emacs-plus
  brew install emacs-plus

  # Register emacs daemon service
  sudo ln -s ./emacs_server.plist /Library/LaunchAgents/emacs_server.plist
  launchctl load -w /Library/LaunchAgents/emacs_server.plist
}

setup_zsh() {
  # Install oh-my-zsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

  # Install zsh-syntax-highlighting
  brew install zsh-syntax-highlighting
}

setup_iterm2() {
  brew install iterm2

  # Disable mouse pointer acceleration

  # Download and install RobotoMono fonts

  # Set RobotoMono font in iterm2
}

setup_karabiner() {
  # Install Karabiner, add PC style shortcuts
  # Latest downloads: https://karabiner-elements.pqrs.org/
  # Need to symlink karabiner folder in here to ~/.config/karabiner
  :
}

setup_helix() {
  brew install helix

  # Symlink helix configs
}

setup_gitu() {
  brew install gitu
}

setup_scroll_reverser() {
  # Install Scroll Reverser (natural scroll for mouse, not trackpad)
  brew install --cask scroll-reverser
}

setup_tmux() {
  # Install tmux and oh-my-tmux
  brew install tmux fzf
  git clone https://github.com/gpakosz/.tmux.git ~/.local/share/tmux/oh-my-tmux
  mkdir -p ~/.config/tmux
  ln -sf ~/.local/share/tmux/oh-my-tmux/.tmux.conf ~/.config/tmux/tmux.conf
  ln -sf ~/dev/personal-configs/tmux/.tmux.conf.local ~/.config/tmux/tmux.conf.local

  # tmux plugins
  git clone https://github.com/fcsonline/tmux-thumbs ~/dev/tmux-thumbs
  cd ~/dev/tmux-thumbs && cargo build --release && cd -
  git clone https://github.com/tmux-plugins/tmux-resurrect ~/dev/tmux-resurrect
  git clone https://github.com/tmux-plugins/tmux-continuum ~/dev/tmux-continuum
}

# Components in run-all order. prereqs is always run first.
COMPONENTS=(emacs zsh iterm2 karabiner helix gitu scroll_reverser tmux)

run_all() {
  setup_prereqs
  export HOMEBREW_NO_INSTALL_CLEANUP=1
  export HOMEBREW_NO_ENV_HINTS=1
  for c in "${COMPONENTS[@]}"; do
    "setup_${c}"
  done
}

run_one() {
  local name="$1"
  if ! declare -F "setup_${name}" >/dev/null; then
    echo "Unknown component: ${name}" >&2
    echo "Available: ${COMPONENTS[*]}" >&2
    return 1
  fi
  # A single component still needs brew present + prompts suppressed.
  setup_prereqs
  export HOMEBREW_NO_INSTALL_CLEANUP=1
  export HOMEBREW_NO_ENV_HINTS=1
  "setup_${name}"
}

case "${1:-}" in
  "")       run_all ;;
  --list|-l) echo "Available components: ${COMPONENTS[*]}" ;;
  *)        for arg in "$@"; do run_one "$arg" || exit 1; done ;;
esac
