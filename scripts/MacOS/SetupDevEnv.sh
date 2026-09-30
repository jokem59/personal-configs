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
  # Pin to @30 (deterministic; the unversioned formula silently tracks whatever
  # major is latest, which is how a macOS/brew update once left us broken).
  brew install emacs-plus@30

  # Point /Applications/Emacs.app at the keg so every GUI launch path — Spotlight,
  # Dock, and the `osascript ... activate` that the Opt+3 emacsclient binding uses
  # to raise the frame — hits this build. (emacs-plus doesn't install into
  # /Applications itself.)
  rm -f /Applications/Emacs.app
  ln -s /opt/homebrew/opt/emacs-plus@30/Emacs.app /Applications/Emacs.app
  /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -f /Applications/Emacs.app

  # Register the Emacs daemon as a per-user LaunchAgent (no sudo; matches the
  # per-user Homebrew install and logs under /tmp). RunAtLoad + KeepAlive keep a
  # single headless daemon alive; the Karabiner Opt+3 binding and the shell
  # `emacsclient` aliases ($EDITOR/$VISUAL, `e`/`et`) all attach to it, so
  # everything shares one Emacs.
  local plist_src="$HOME/dev/personal-configs/scripts/MacOS/emacs_server.plist"
  local plist_dst="$HOME/Library/LaunchAgents/emacs_server.plist"

  # Drop any stale system-wide copy from older setups: it collides on the same
  # "emacs_server" label and historically pointed at an older emacs-plus keg.
  if [ -e /Library/LaunchAgents/emacs_server.plist ]; then
    sudo launchctl bootout system/emacs_server 2>/dev/null || true
    sudo rm -f /Library/LaunchAgents/emacs_server.plist
  fi

  mkdir -p "$HOME/Library/LaunchAgents"
  ln -sf "$plist_src" "$plist_dst"
  # Modern launchd verbs (bootout/bootstrap) targeting the per-user GUI domain.
  # The legacy `launchctl load -w` / `unload` throw "Input/output error" (EIO)
  # on recent macOS even against a valid plist, so use bootstrap explicitly.
  launchctl bootout "gui/$(id -u)/emacs_server" 2>/dev/null || true
  launchctl bootstrap "gui/$(id -u)" "$plist_dst"

  # Build the Finder file-open handler for the daemon: a tiny wrapper .app (from
  # tracked AppleScript source) that hands double-clicked / "Open With" files to
  # open-in-emacs.sh, which opens them in the shared daemon via emacsclient (it
  # also focuses a frame on a bare launch, as a harmless fallback). Register it
  # with Launch Services and set it as the default handler for code/text files
  # (setup_helix no longer claims these).
  #
  # This applet is NOT the Dock icon. Pin the real /Applications/Emacs.app to the
  # Dock instead: init-ui.el keeps the daemon owning >=1 GUI frame, so the daemon
  # is always a registered `org.gnu.Emacs' app whose tile coalesces with the
  # pinned Emacs.app, and clicking it activates the daemon rather than spawning a
  # standalone GUI Emacs (the process split behind the old "Opt+3 opens a new
  # frame" / stray-background-Emacs symptoms).
  brew install duti
  local repo="$HOME/dev/personal-configs/emacs"
  local app="$HOME/Applications/EmacsOpener.app"
  local plist="$app/Contents/Info.plist"
  local pb=/usr/libexec/PlistBuddy

  mkdir -p "$HOME/Applications"
  rm -rf "$app"
  osacompile -o "$app" "$repo/emacs-opener.applescript"

  # Stable bundle id (so duti can target it) + declare it an editor for
  # text/source/data so Launch Services accepts it as a default handler.
  # osacompile apps have no CFBundleIdentifier — add it (Set if somehow present).
  "$pb" -c "Add :CFBundleIdentifier string com.joekim.emacsopener" "$plist" 2>/dev/null \
    || "$pb" -c "Set :CFBundleIdentifier com.joekim.emacsopener" "$plist"
  # Deliberately NOT named "Emacs": the pinned Dock icon is the real Emacs.app
  # (org.gnu.Emacs); this stays "EmacsOpener" so it doesn't masquerade as a
  # second Emacs in the app switcher / Spotlight.
  "$pb" -c "Add :CFBundleDocumentTypes array" "$plist" 2>/dev/null || true
  "$pb" -c "Add :CFBundleDocumentTypes:0 dict" "$plist"
  "$pb" -c "Add :CFBundleDocumentTypes:0:CFBundleTypeName string Text/Source" "$plist"
  "$pb" -c "Add :CFBundleDocumentTypes:0:CFBundleTypeRole string Editor" "$plist"
  "$pb" -c "Add :CFBundleDocumentTypes:0:LSItemContentTypes array" "$plist"
  "$pb" -c "Add :CFBundleDocumentTypes:0:LSItemContentTypes:0 string public.text" "$plist"
  "$pb" -c "Add :CFBundleDocumentTypes:0:LSItemContentTypes:1 string public.source-code" "$plist"
  "$pb" -c "Add :CFBundleDocumentTypes:0:LSItemContentTypes:2 string public.data" "$plist"

  # Register with Launch Services, then set the default associations.
  /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -f "$app"
  sh "$repo/set-emacs-defaults.sh"
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

  # NOTE: Helix is no longer the default Finder handler for text/code files.
  # That role moved to EmacsOpener.app (see setup_emacs). The tracked
  # helix-opener.applescript / open-in-helix.sh / set-helix-defaults.sh are kept
  # if you ever want to switch back — run set-helix-defaults.sh to reclaim them.
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
