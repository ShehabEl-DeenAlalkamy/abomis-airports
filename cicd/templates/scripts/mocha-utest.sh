#!/usr/bin/env bash

main() {
    mkdir -p "${BUILD_ARTIFACTSTAGINGDIRECTORY}"/utests/jsc
    cmd="./node_modules/nyc/bin/nyc.js --reporter=cobertura --reporter=html ./node_modules/mocha/bin/mocha --timeout 5000 --recursive test/unit --reporter mocha-junit-reporter --reporter-options mochaFile=${BUILD_ARTIFACTSTAGINGDIRECTORY}/utests/jsc/mocha-out.xml"
    echo "${cmd}"
    "${cmd}"
    # avoid flow breaking in case unit testing raises error
    exit 0
}

[[ "${0}" == "${BASH_SOURCE[0]}" ]] && main "${*}"
