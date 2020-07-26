# Chromium
sudo apt-get install chromium

# Curl
sudo apt-get install curl

# Syncthing
# Add the release PGP keys:
curl -s https://syncthing.net/release-key.txt | sudo apt-key add -

# Add the "stable" channel to your APT sources:
echo "deb https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list

# Update and install syncthing:
sudo apt-get update
sudo apt-get install syncthing

# Install Emacs

# Remove ~/.emacs.d and replace with symlink to ~/dev/personal-configs
# DELETE ~/.emacs.d
ln -s ~/dev/personal-configs/emacs/.emacs.d/ ~/.emacs.d


# Add case insensitive auto-completion
if grep -qi completion-ignore-case /etc/inputrc; then
    echo -e "\ncompletion-ignore-case already set to On"
else
    echo -e "\nset completion-ignore-case On" | sudo tee -a /etc/inputrc
fi
