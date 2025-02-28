#!/bin/bash

# Installer Script for ChipScript
# This script ensures that the ChipScript master script is sourced from .bashrc

chip_script_path="$HOME/ChipScript/master.sh"
source_line="source \"$chip_script_path\""
bashrc_path="$HOME/.bashrc"

add_source_line() {
    echo "Adding ChipScript initialization to .bashrc..."
    {
        echo -e "\n# Loads the ChipScript script manager"
        echo "$source_line"
    } >> "$bashrc_path"
}

if grep -Fxq "$source_line" "$bashrc_path"; then
    echo "ChipScript is already configured in .bashrc."
else
    if add_source_line; then
        source ~/.bashrc
        echo "ChipScript initialization added successfully."
    else
        echo "Failed to configure ChipScript in .bashrc. Check permissions or disk space." >&2
        exit 1
    fi
fi
