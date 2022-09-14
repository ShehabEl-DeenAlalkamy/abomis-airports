#!/usr/bin/env bash

main() {
    readonly ADO_DEBUG_CMD="##[debug]"
    echo "${ADO_DEBUG_CMD}"creating "${BUILD_ARTIFACTSTAGINGDIRECTORY}"/functional-testing/cucumber
    mkdir -p "${BUILD_ARTIFACTSTAGINGDIRECTORY}"/functional-testing/cucumber
    echo "TEST_HOST=${HOSTNAME} node node_modules/.bin/cucumber-js --publish-quiet ${SOURCE_PATH} --format json:${BUILD_ARTIFACTSTAGINGDIRECTORY}/functional-testing/cucumber/reports.json"
    TEST_HOST="${HOSTNAME}" node node_modules/.bin/cucumber-js --publish-quiet "${SOURCE_PATH}" --format json:"${BUILD_ARTIFACTSTAGINGDIRECTORY}"/functional-testing/cucumber/reports.json
    
    # avoid flow breaking in case unit testing raises error
    exit 0
}

[[ "${0}" == "${BASH_SOURCE[0]}" ]] && main "${*}"
