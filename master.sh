#!/bin/bash

# This is the master file of ChipScript, which serves as the central script for managing the system.
# Load system environment variables and configurations.
export SCRIPT_PATH="$HOME/ChipScript"
source "$SCRIPT_PATH/system.sh"

# Load specific modules from the ChipScript collection.
chipi.load makeHtml
chipi.load checkSize

# Instructions for expanding ChipScript:
# - Place custom scripts in the 'scripts' folder.
# - Use 'main.sh' in each script folder as the definition base for aliases, functions, and variables,
#   since 'main.sh' is automatically loaded.
# - Optional 'help.sh' is executed when 'help' is called; use 'echo' commands there for guidance messages.
# - Optional 'install.sh' can be used to handle script installation processes when loaded.
# - 'main.sh' is essential for each script to function within the ChipScript framework.

# To create a new script template or edit an existing script:
# - Use 'chipi.create <name>' to generate a new script template.
# - Use 'chipi.code <name>' to open and edit a script.

# To ensure scripts are loaded at startup:
# - Use 'chipi.load <name>' to automatically load the script.
# - 'chipi.load' also adjusts permissions, runs 'install.sh', and incorporates 'main.sh' into '.bashrc' for persistence.
