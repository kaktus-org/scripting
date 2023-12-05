#!/usr/bin/env bash

log() {
    local level
    local message
    local script_name=$(basename "$0")
    local color
    local reset_color=$(tput sgr0)

    if [ $# -eq 2 ]; then
        level=${1}
        message=${2}
    else
        level=INFO
        message=${1}
    fi

    case $level in
        INFO) color=$(tput setaf 2);;  # Green
        WARN) color=$(tput setaf 3);;  # Yellow
        ERROR) color=$(tput setaf 1);; # Red
        *) color=$(tput setaf 7);;     # White
    esac

    echo -e "${color}[$(date '+%Y-%m-%d %H:%M:%S')] (${script_name}) ${level}: ${reset_color} ${message}"
}
