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
