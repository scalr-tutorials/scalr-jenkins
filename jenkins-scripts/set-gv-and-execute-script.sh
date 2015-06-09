#!/bin/bash
set -o errexit
set -o nounset

# API Client Configuration -- The user is expected to replace this.
# The best practice would be to use e.g. the Credentials Binding plugin to
# feed the credentials directly into the script.
SCALR_API_URL="https://api.scalr.net"
SCALR_API_KEY_ID="<Key ID goes here>"
SCALR_API_KEY_SECRET="<Key Secret goes here>"
SCALR_API_ENV_ID="<Environment ID goes here>"

# Target configuration -- The user is expected to replace this as well.
# The best practice here would be to set those using e.g. Jenkins parameters.
FARM_ID="<ID of the target Farm>"

# Deployment script configuration -- This is also expected to be customized.
# It is good practice to use a script that just fires an Event, and use Orchestration to
# actually execute the deployment script. This allows you to use Orchestration to choose
# which Farm Role(s) execute the deployment script.
DEPLOY_SCRIPT_ID="<ID of the Script used to deploy the app>"
DEPLOY_SCRIPT_TIMEOUT="180"
DEPLOY_SCRIPT_MODE="1"  # (1 = async, 0 = sync)

# Actual script starts here
pip install scalr

scalr -i "${SCALR_API_KEY_ID}" -a "${SCALR_API_KEY_SECRET}" -u "${SCALR_API_URL}" -e "${SCALR_API_ENV_ID}" \
  "set-global-variable" -k "JENKINS_LAST_BUILD" -v "${BUILD_ID}" -f "${FARM_ID}"

scalr -i "${SCALR_API_KEY_ID}" -a "${SCALR_API_KEY_SECRET}" -u "${SCALR_API_URL}" -e "${SCALR_API_ENV_ID}" \
  "execute-script" -e "${DEPLOY_SCRIPT_ID}" -t "${DEPLOY_SCRIPT_TIMEOUT}" -a "${DEPLOY_SCRIPT_MODE}" -f "${FARM_ID}"

