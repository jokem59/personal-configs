#source $(brew --prefix)/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
if command -v brew &>/dev/null; then
    source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [ -f "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [ -f "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Open emacs terminal and attach to existing deamon, passing along any args
alias e='emacsclient -r -n -a "" "$@"'
alias et='emacsclient -nw -a "" "$@"'
alias h='hx'
alias ll="ls -alt"

# Option+Left/Right (Karabiner remaps Cmd+B/F here) — bind the xterm CSI form
bindkey '^[[1;3D' backward-word
bindkey '^[[1;3C' forward-word
# Fn+Option+Forward-Delete (Karabiner remaps Cmd+D here) — delete word forward
bindkey '^[[3;3~' kill-word

# Default editor related settings
export ALTERNATE_EDITOR=""
export EDITOR="hx"                  # $EDITOR opens in terminal
export VISUAL='hx'         # $VISUAL opens in GUI mode

# Show start time + duration after each command
zmodload zsh/datetime
preexec() { _cmd_start=$EPOCHREALTIME; }
precmd()  {
    [[ -z $_cmd_start ]] && return
    local elapsed=$(( EPOCHREALTIME - _cmd_start ))
    printf '\e[90m[%s, took %.2fs]\e[0m\n' "$(date +%H:%M:%S)" "$elapsed"
    unset _cmd_start
}

export PATH=$PATH:${BREW_BIN}
if command -v go &>/dev/null; then
    export PATH=$PATH:$(go env GOPATH)/bin
fi

# Source work specific functions
if [ -f ~/git/roblox/scripts/.rbx_zshrc ]; then
    source ~/git/roblox/scripts/.rbx_zshrc
fi

# Source helper scripts
if [ -f ~/git/roblox/scripts/fflag.sh ]; then
    source ~/git/roblox/scripts/fflag.sh
fi

# st requires this export for programs like helix to detect true color support
export COLORTERM=truecolor

# Open a terminal frame (-t) on the shared Emacs daemon (launchd's emacs_server;
# $ALTERNATE_EDITOR="" starts one only if it's down). 'em -' reads stdin into a
# *stdin* buffer; the frame itself reads keys from /dev/tty since stdin is the pipe.
# Files (and +LINE) are opened via --eval find-file rather than as emacsclient
# args, so they aren't owned by this client and survive C-x C-c / C-x 5 0
# (server-kill-new-buffers would otherwise kill them when the frame closes).
function em()
{
    if [[ "$1" == "-" ]]; then
        local tmp="$(mktemp /tmp/emacsstdin-XXX)"
        cat >"$tmp"
        emacsclient -t --eval "(let ((b (generate-new-buffer \"*stdin*\"))) (switch-to-buffer b) (insert-file-contents \"$tmp\") (delete-file \"$tmp\"))" </dev/tty
        return
    fi
    local -a opts forms
    local arg line=""
    for arg in "$@"; do
        case "$arg" in
            +[0-9]*) line="${arg#+}" ;;
            -*)      opts+=("$arg") ;;
            *)       forms+=("(find-file ${(qqq)arg:a})${line:+ (goto-line $line)}"); line="" ;;
        esac
    done
    if (( ${#forms} )); then
        emacsclient -t "${opts[@]}" --eval "(progn ${forms[*]})"
    else
        emacsclient -t "${opts[@]}"
    fi
}

#eval `dircolors ~/.dir_colors/dircolors`
if [[ "$OSTYPE" == "darwin"* ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
else
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# zsh-syntax-highlighting styles comments as `fg=black,bold` by default, which
# renders as literal black (ANSI color 0) and is unreadable on a dark theme
# (e.g. doom-dark+ in eat). Use a mid gray from the 256-color cube instead of a
# palette color name so it stays legible across every terminal (eat, alacritty,
# wezterm, tmux, st) regardless of that terminal's color-0/8 mapping.
ZSH_HIGHLIGHT_STYLES[comment]='fg=245'

# This must be at the bottom to prevent oh-my-zsh settings from overriding
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=1000000000
export SAVEHIST=1000000000
setopt EXTENDED_HISTORY
if [ -f "$HOME/.local/bin/env" ]; then
    . "$HOME/.local/bin/env"
elif [ -f "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion


# eat (emacs terminal) shell integration: prompt + directory tracking.
# Sourced last so its precmd/preexec hooks and widgets aren't overridden by
# oh-my-zsh or the plugins above. No-op outside eat.
if [[ -n "$EAT_SHELL_INTEGRATION_DIR" ]]; then
    source "$EAT_SHELL_INTEGRATION_DIR/zsh"
fi

# Added by Antigravity CLI installer
export PATH="/home/jokem/.local/bin:$PATH"


# Added by Antigravity CLI installer
export PATH="/Users/joekim/.local/bin:$PATH"
export PATH="/Users/joekim/.local/bin:$PATH"
