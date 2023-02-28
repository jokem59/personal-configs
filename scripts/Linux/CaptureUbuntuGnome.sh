#!/bin/bash

# Abort on non-zero exit status, abort on unbound variable, don't hide errors in pipes
set -euo pipefail

function capture_gnome_env() {
    dconf dump /org/gnome/terminal/ > ~/dev/personal-configs/gnome-terminal/gterminal.preferences
    dconf dump / > ~/dev/personal-configs/gnome-settings/gnome_settings.dconf
}

capture_gnome_env
