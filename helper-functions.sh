#!/usr/bin/env bash

capture_positional_argument() {
    local __resultVar=${1}
    local argument=$2
    local param_name=$3

    if [[ -z "${argument}" ]]; then
        echo "Error: Argument for ${param_name} is required."
        exit 1
    else
        eval "$__resultVar"="'${argument}'"
        shift 2
    fi
}

capture_required_arguments() {
    local current_arg=$1
    shift
    local -n required_args=$1
    for arg_name in "${required_args[@]}"; do
        if [[ -z "${!arg_name}" ]]; then
            eval "$arg_name='$current_arg'"
            return
        fi
    done
    echo "Erorr: Too many arguments provided."
    exit 1
}

verify_required_arguments() {
    local -a arg_names=("${!1}")
    local missing_args=()

    for arg in "${arg_names[@]}"; do
        if [[ -z "${!arg}" ]]; then
            missing_args+=("$arg")
        fi
    done

    if [[ ${#missing_args[@]} -gt 0 ]]; then
        echo "Error: The following arguments are not specified: ${missing_args[*]}"
        return 1
    fi
}

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
