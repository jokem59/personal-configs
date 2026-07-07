# Install HomeBrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install emacs
brew tap d12frosted/emacs-plus
brew install emacs-plus

# Register emacs daemon service
sudo ln -s ./emacs_server.plist /Library/LaunchAgents/emacs_server.plist
launchctl load -w /Library/LaunchAgents/emacs_server.plist

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install zsh-syntax-highlighting
brew install zsh-syntax-highlighting

# Download iTerm2
brew install iterm2

# Disable mouse pointer acceleration

# Download and install RobotoMono fonts

# Set RobotoMono font in iterm2

# Install Karabiner, add PC style shortcuts
# Latest downloads: https://karabiner-elements.pqrs.org/
# Need to symlink karabiner folder in here to ~/.config/karabiner

# Install helix editor
brew install helix

# Symlink helix configs

# Install gitu
brew install gitu

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
