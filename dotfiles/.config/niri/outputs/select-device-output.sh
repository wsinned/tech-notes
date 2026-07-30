#!/bin/sh

set -eu

config_home="${XDG_CONFIG_HOME:-${HOME}/.config}"
output_dir="${config_home}/niri/outputs"
device="$(hostname)"
device_config="${output_dir}/${device}.kdl"
current_config="${output_dir}/current.kdl"

if [ -f "${device_config}" ]; then
    current_target="$(readlink "${current_config}" 2> /dev/null || true)"
    if [ "${current_target}" != "${device}.kdl" ]; then
        ln -sfn -- "${device}.kdl" "${current_config}"
    fi
elif [ -L "${current_config}" ]; then
    rm -- "${current_config}"
fi
