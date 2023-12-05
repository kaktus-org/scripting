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

verify_dependency() {
    local dependency=${1}
    if ! command -v "${dependency}" &> /dev/null; then
        echo "Error: Required dependency '${dependency}' is not installed." >&2
        return 1
    fi
}

verify_dockerised() {

    # This is a very commonly used method to verify that you are
    # within a docker container. However, the .dockerenv file is
    # not intended to be used this way. Despite this, it seems to
    # be left untouched, likely because of this fact.
    #
    # See: https://github.com/moby/moby/issues/18355#issuecomment-220484748

    if [ -f /.dockerenv ]; then
        return 0
    fi

    # As the above method may be fragile, let's also check here.
    
    if grep -qE '/docker/' /proc/self/cgroup; then
        return 0
    fi

    return 1
}
