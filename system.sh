#!/bin/bash

alias chipi.version="echo ChipScript 1.1.0 🐿️"
alias chipi.reload="source ~/.bashrc"
alias chipi.list="ls -a $SCRIPT_PATH/scripts"
alias chipi.git="git -C \"$SCRIPT_PATH\""
alias chipi.pull="git -C \"$SCRIPT_PATH\" pull"
alias chipi.push="git -C \"$SCRIPT_PATH\" push"
alias chipi.commit="git -C \"$SCRIPT_PATH\" add . && git -C \"$SCRIPT_PATH\" commit -m"

function chipi.edit() {
    if [[ $1 == "--help" || $1 == "-h" ]]; then
        echo "Usage: chipi.edit [system|master|directory] [script]"
        echo "Description: Opens a script in the text editor (micro)."
        echo "  - 'system' or 'master' edits the main system scripts."
        echo "  - Specifying a directory and script name opens that script."
        echo "Example:"
        echo "  chipi.edit myscript main  # Edit 'main.sh' in 'myscript'"
        return
    fi
    if [[ $1 == "master" || $1 == "system" ]]; then
        micro "$SCRIPT_PATH/${1}.sh"
    else
        micro "$SCRIPT_PATH/scripts/${1}/${2}.sh"
    fi
}

function chipi.code() {
    if [[ $1 == "--help" || $1 == "-h" ]]; then
        echo "Usage: chipi.code [system|master|directory]"
        echo "Description: Opens VS Code in the specified directory or at the root level."
        echo "  - 'system' or 'master' opens VS Code at the root script directory."
        echo "  - Specifying a directory opens VS Code in that script folder."
        echo "Example:"
        echo "  chipi.code myscript  # Open 'myscript' directory in VS Code"
        return
    fi
    if [[ $1 == "master" || $1 == "system" ]]; then
        code "$SCRIPT_PATH/"
    else
        code "$SCRIPT_PATH/scripts/${1}"
    fi
}

function chipi.create() {
    if [[ $1 == "--help" || $1 == "-h" ]]; then
        echo "Usage: chipi.create [directory]"
        echo "Description: Creates a new script directory with default scripts."
        echo "  - This initializes a new folder with 'main.sh' and 'help.sh'."
        echo "Example:"
        echo "  chipi.create myscript  # Creates 'myscript' with default scripts"
        return
    fi
    mkdir -p "$SCRIPT_PATH/scripts/${1}"
    echo "" > "$SCRIPT_PATH/scripts/${1}/main.sh"
    echo "" > "$SCRIPT_PATH/scripts/${1}/help.sh"
}

function chipi.remove() {
    if [[ $1 == "--help" || $1 == "-h" ]]; then
        echo "Usage: chipi.remove [directory]"
        echo "Description: Deletes a specified script directory or file, with protections against removing critical scripts."
        echo "  - Files 'master.sh' and 'system.sh' are protected and cannot be removed."
        echo "Example:"
        echo "  chipi.remove myscript  # Deletes 'myscript' directory or file if it is not protected"
        return
    fi

    local target_path=$(realpath "$SCRIPT_PATH/scripts/$1")
    local base_name=$(basename "$target_path")

    if [[ "$base_name" == "master.sh" || "$base_name" == "system.sh" ]]; then
        echo -e "\033[0;31mCannot remove protected file '$base_name'.\033[0m"
    else
        if [[ -e "$target_path" ]]; then
            rm -r "$target_path"
            echo "Target '$1' removed successfully."
        else
            echo "Target '$1' does not exist."
        fi
    fi
}


function chipi.allow() {
    if [[ $1 == "--help" || $1 == "-h" ]]; then
        echo "Usage: chipi.allow [directory]"
        echo "Description: Grants execution permissions to key scripts."
        echo "  - Makes 'main.sh', 'help.sh', and 'install.sh' executable."
        echo "Example:"
        echo "  chipi.allow myscript  # Grants execute permissions in 'myscript'"
        return
    fi

    local script_directory="$SCRIPT_PATH/scripts/$1"

    if [[ -d "$script_directory" ]]; then
        chmod +x "$script_directory"/*.sh 2>/dev/null || echo "No scripts found in $1."
    else
        echo "ERROR: Script directory $1 does not exist."
    fi
}

function chipi.install() {
    if [[ $1 == "--help" || $1 == "-h" ]]; then
        echo "Usage: chipi.install [directory]"
        echo "Description: Executes 'install.sh' from the specified directory if present."
        echo "Example:"
        echo "  chipi.install myscript  # Executes 'install.sh' in 'myscript'"
        return
    fi

    local script_directory="$SCRIPT_PATH/scripts/$1"
    if [[ -d "$script_directory" ]]; then
        if [[ -f "$script_directory/install.sh" ]]; then
            "$script_directory/install.sh"
        fi
    else
        echo "Script directory '$1' does not exist."
    fi
}

function chipi.load() {
    if [[ $1 == "--help" || $1 == "-h" ]]; then
        echo "Usage: chipi.load [script]"
        echo "Description: Modifies permissions, installs activation components, and executes the main.sh file from a specified script directory (modular script)."
        echo "  - Changes permissions using chmod to ensure executability."
        echo "  - Installs any dependencies or setup required by the script."
        echo "  - Executes the main.sh file to load the modular script's functionality."
        echo "Example:"
        echo "  chipi.load myscript  # Changes permissions, installs, and executes 'main.sh' from 'myscript' directory"
        return
    fi
    if [[ -f "$SCRIPT_PATH/scripts/${1}/main.sh" ]]; then
        chipi.allow ${1}  # This function should include the chmod operation
        chipi.install ${1}
        source "$SCRIPT_PATH/scripts/${1}/main.sh"
    else
        echo "Error: No file main.sh found for ${1}"
    fi
}

function chipi.help() {
    if [[ $1 == "--help" || $1 == "-h" ]]; then
        echo "Usage: chipi.help [script]"
        echo "Description: Displays help documentation for a specified script."
        echo "  - Runs 'help.sh' in the script directory if present."
        echo "Example:"
        echo "  chipi.help myscript  # Shows help for 'myscript'"
        return
    fi
    if [[ -d "$SCRIPT_PATH/scripts/${1}" ]]; then
        [[ -f "$SCRIPT_PATH/scripts/${1}/help.sh" ]] && bash "$SCRIPT_PATH/scripts/${1}/help.sh" || echo "No documentation available for $1."
        [[ ! -f "$SCRIPT_PATH/scripts/${1}/main.sh" ]] && echo "No Script path available at ${1}/main.sh"
    else
        echo "Script directory ${1} does not exist."
    fi
}


function chipi() {
    # Displaying general overview of ChipScript commands
    echo "Chipi Command Help Overview:"
    echo ""
    echo "chipi.version - Displays the current version of ChipScript"
    echo ""
    echo "chipi.reload - Reloads the user's .bashrc file to apply new settings"
    echo ""
    echo "chipi.list - Lists all scripts within the specified script path"
    echo ""
    echo "Detailed command help:"
    echo ""

    # Section for editing scripts
    echo "Editing scripts:"
    chipi.edit --help
    echo ""

    # Section for opening scripts in Visual Studio Code
    echo "Opening scripts in VS Code:"
    chipi.code --help
    echo ""

    # Section for creating new script directories
    echo "Creating new script directories:"
    chipi.create --help
    echo ""

    # Section for removing script directories or files
    echo "Removing script directories or files:"
    chipi.remove --help
    echo ""

    # Section for granting execution permissions
    echo "Granting execution permissions:"
    chipi.allow --help
    echo ""

    # Section for executing 'install.sh' from a directory
    echo "Executing 'install.sh' from a directory:"
    chipi.install --help
    echo ""

    # Section for loading and executing modular scripts
    echo "Loading and executing modular scripts:"
    chipi.load --help
    echo ""

    # Section for providing help documentation
    echo "Providing help documentation:"
    chipi.help --help
    echo ""

    # Section for Git commands
    echo "Git commands for script management:"
    echo "  chipi.git <command>  - Runs Git commands in the ChipScript repo"
    echo "  chipi.pull           - Pulls latest updates"
    echo "  chipi.push           - Pushes committed changes"
    echo "  chipi.commit \"msg\"  - Commits changes with a message"
    echo ""
}
