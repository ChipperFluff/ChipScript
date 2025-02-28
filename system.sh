#!/bin/bash

alias chipi.reload="source ~/.bashrc"

alias chipi.list="ls -a $SCRIPT_PATH/scripts"

function chipi.edit() {
    micro "$SCRIPT_PATH/scripts/${1}/${2}.sh"
}

function chipi.create() {
    mkdir -p "$SCRIPT_PATH/scripts/${1}"
    echo "" > "$SCRIPT_PATH/scripts/${1}/main.sh"
    echo "" > "$SCRIPT_PATH/scripts/${1}/help.sh"
}

function chipi.remove() {
    micro "rm -r $SCRIPT_PATH/scripts/${1}"
}

function chipi.remove() {
    if [[ $1 == "master" || $1 == "system" ]]; then
        echo -e "\033[0;31mNo\033[0m"
    else
        local full_path=$(eval echo "${SCRIPT_PATH}/${1}.sh")
        rm "$full_path"
    fi
}

function chipi.allow() {
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
    if [[ -f "$SCRIPT_PATH/scripts/${1}/main.sh" ]]; then
        chipi.allow ${1}
        source "$SCRIPT_PATH/scripts/${1}/main.sh"
    else
        echo "Error: No file main.sh found for ${1}"
    fi
}

function chipi.help() {
    if [[ -d "$SCRIPT_PATH/scripts/${1}" ]]; then
        if [[ -f "$SCRIPT_PATH/scripts/${1}/help.sh" ]]; then
            "$SCRIPT_PATH/scripts/${1}/help.sh"
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
