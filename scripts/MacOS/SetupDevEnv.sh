
# Install HomeBrew

# Install MacForOSX

# Download and install RobotoMono fonts

# Download iTerm2
brew install iterm2

# Download Oh-My-Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Enable iTerm2 syntax highlighting
cd ~/.oh-my-zsh
git clone git://github.com/zsh-users/zsh-syntax-highlighting.git
echo "source ${(q-)PWD}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc

# Power Level 9K
brew tap sambadevi/powerlevel9k
brew install powerlevel9k



