#!/usr/bin/env bash

main() {
    echo CONFIG_LIST: 
    echo "${CONFIG_LIST}"
}

[[ "${0}" == "${BASH_SOURCE[0]}" ]] && main "${*}"
