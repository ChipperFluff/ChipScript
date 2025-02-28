#!/bin/bash

alias chipi.version="echo ChipScript 1.0.0 🐿️"
alias chipi.reload="source ~/.bashrc"
alias chipi.list="ls -a $SCRIPT_PATH/scripts"

function chipi.edit() {
    if [[ $1 == "--help" || $1 == "-h" ]]; then
        echo "Usage: chipi.edit [system|master|directory] [script]"
        echo "Edit the specified script in the directory or master/system script directly."
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
        echo "Open VS Code in the specified directory or at the root level for system/master."
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
        echo "Create a new script directory with a main and help script."
        return
    fi
    mkdir -p "$SCRIPT_PATH/scripts/${1}"
    echo "" > "$SCRIPT_PATH/scripts/${1}/main.sh"
    echo "" > "$SCRIPT_PATH/scripts/${1}/help.sh"
}

function chipi.remove() {
    if [[ $1 == "--help" || $1 == "-h" ]]; then
        echo "Usage: chipi.remove [directory]"
        echo "Remove the specified script directory, excluding master/system directories."
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
        echo "Grant execute permissions to all scripts in the directory recursively."
        return
    fi
    if [[ -d "$SCRIPT_PATH/scripts/$1" ]]; then
        find "$SCRIPT_PATH/scripts/$1" -type f -name '*.sh' -exec chmod +x {} +
        if [[ ! $(find "$SCRIPT_PATH/scripts/$1" -type f -name '*.sh') ]]; then
            echo "No .sh scripts found in $1."
        fi
    else
        echo "Script directory $1 does not exist."
    fi
}

function chipi.load() {
    if [[ $1 == "--help" || $1 == "-h" ]]; then
        echo "Usage: chipi.load [script]"
        echo "Load and execute the main script from the specified directory."
        return
    fi
    if [[ -f "$SCRIPT_PATH/scripts/${1}/main.sh" ]]; then
        chipi.allow ${1}
        source "$SCRIPT_PATH/scripts/${1}/main.sh"
    else
        echo "Error: No file main.sh found for ${1}"
    fi
}

function chipi.help() {
    if [[ $1 == "--help" || $1 == "-h" ]]; then
        echo "Usage: chipi.help [script]"
        echo "Display the help documentation for the specified script."
        return
    fi
    if [[ -d "$SCRIPT_PATH/scripts/${1}" ]]; then
        if [[ -f "$SCRIPT_PATH/scripts/${1}/help.sh" ]]; then
            bash "$SCRIPT_PATH/scripts/${1}/help.sh"
        else
            echo "No documentation available for $1."
        fi
        if [[ ! -f "$SCRIPT_PATH/scripts/${1}/main.sh" ]]; then
            echo "No Script path available at ${1}/main.sh"
        fi
    else
        echo "Script directory ${1} does not exist."
    fi
}
