#!/bin/bash

# Abort on non-zero exit status, abort on unbound variable, don't hide errors in pipes
set -euo pipefail

source SetupFunctions.sh

############
### Main ###
############
# NOTE: Need to setup zsh separately
# Usage: sudo ./SetupUbuntuDevEnv.sh -u $(echo $USERNAME)

while getopts u: opt; do
    case $opt in
        u) real_user=$OPTARG ;;
        *)
             echo 'Error in command line parsing' >&2
             exit 1
    esac
done

shift "$(( OPTIND - 1 ))"

if [ -z "$real_user" ]; then
    echo 'Missing -u <username>' >&2
    exit 1
fi

if ! [ $(id -u) = 0 ]; then
   echo "The script need to be run as root." >&2
   exit 1
fi

echo
echo "INFO: Script is run with username ${real_user}"

# Commands that you don't want running as root would be invoked
# with: sudo -u $real_user
# So they will be run as the user who invoked the sudo command
# Keep in mind if the user is using a root shell (they're logged in as root),
# then $real_user is actually root
# sudo -u $real_user non-root-command

# Commands that need to be ran with root would be invoked without sudo
# root-command

read -p "Has personal-configs been cloned to ${PERSONAL_CONFIGS}? " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

# hwloc = lstopo
apt install curl wget xclip tmux gnome-tweaks ripgrep shellcheck htop hwloc dconf-cli blueman gnome-clocks convert plocate -y

setup_emacs
setup_vim
setup_gnome_terminal
setup_tmux
setup_syncthing
setup_gnome_settings
get_latex_packages
setup_st

# Add case insensitive auto-completion
if grep -qi completion-ignore-case /etc/inputrc; then
    echo -e "\ncompletion-ignore-case already set to On"
else
    echo -e "\nset completion-ignore-case On" | sudo tee -a /etc/inputrc
fi

