#!/usr/bin/env bash

main() {
    readonly ADO_DEBUG_CMD="##[debug]"
    echo "${ADO_DEBUG_CMD}"Supplied Configs:
    echo "${ADO_DEBUG_CMD}"-----------------
    apigee_config_goals
    for config in $(echo "${CONFIG_LIST}" | jq -r '.[]'); do
        echo "${ADO_DEBUG_CMD}- ${config}":
        apigee_config_goals+=" apigee-config:${config}"
    done
    # trim apigee_config_goals
    apigee_config_goals=$(echo "${apigee_config_goals}" | xargs)
    echo "${ADO_DEBUG_CMD}"Apigee Config Goals: "${apigee_config_goals}"
    echo "##vso[task.setvariable variable=Framework.Config.Mvn.ApigeeConfigGoals]${apigee_config_goals}"
}

[[ "${0}" == "${BASH_SOURCE[0]}" ]] && main "${*}"
