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

# Install gitu
brew install gitu
