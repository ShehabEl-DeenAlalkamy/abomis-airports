#!/usr/bin/env bash

main() {
    echo CONFIG_LIST: 
    for config in ${{ parameters.configList }}; do 
        echo "${config}"
    done
}

[[ "${0}" == "${BASH_SOURCE[0]}" ]] && main "${*}"
