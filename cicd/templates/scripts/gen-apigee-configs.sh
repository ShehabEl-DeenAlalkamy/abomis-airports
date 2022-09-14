#!/usr/bin/env bash

main() {
    apigee_config_goals
    for config in $(echo "${CONFIG_LIST}" | jq -r '.[]'); do
        apigee_config_goals+=" apigee-config:${config}"
    done
    echo untrimmed apigee_config_goals: 
    "${apigee_config_goals}"
    echo trimmed apigee_config_goals: 
    "${apigee_config_goals##*( )}"
}

[[ "${0}" == "${BASH_SOURCE[0]}" ]] && main "${*}"
