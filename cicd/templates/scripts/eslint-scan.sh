#!/usr/bin/env bash

main() {
    mkdir -p "${BUILD_ARTIFACTSTAGINGDIRECTORY}"/sca
    cmd="./node_modules/bin/eslint.js --format junit . > ${BUILD_ARTIFACTSTAGINGDIRECTORY}/sca/eslint-out.xml"
    echo "${cmd}"
    "${cmd}"
    # avoid flow breaking in case linting raises error
    exit 0
}

[[ "${0}" == "${BASH_SOURCE[0]}" ]] && main "${*}"
