#!/bin/bash

alias chipi.version="echo ChipScript 1.0.0 \U0001F43F️"
alias chipi.reload="source ~/.bashrc"
alias chipi.list="ls -a $SCRIPT_PATH/scripts"

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
        micro "$SCRIPT_PATH/scripts/${1}.sh"
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
        echo "Description: Deletes a specified script directory."
        echo "  - 'system' and 'master' cannot be removed."
        echo "Example:"
        echo "  chipi.remove myscript  # Deletes 'myscript' directory"
        return
    fi
    if [[ $1 == "master" || $1 == "system" ]]; then
        echo -e "\033[0;31mNo\033[0m"
    else
        rm -r "$SCRIPT_PATH/scripts/${1}"
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
        echo "Description: Loads and executes a script from the specified directory."
        echo "  - Grants permissions and installs before execution."
        echo "Example:"
        echo "  chipi.load myscript  # Loads and runs 'myscript'"
        return
    fi
    if [[ -f "$SCRIPT_PATH/scripts/${1}/main.sh" ]]; then
        chipi.allow ${1}
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
