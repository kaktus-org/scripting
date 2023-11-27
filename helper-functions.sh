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
