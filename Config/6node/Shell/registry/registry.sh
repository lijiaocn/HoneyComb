#!/bin/bash

. /export/Shell/config-global/base.sh
. /export/Shell/config-global/config
. /export/Shell/config-global/library.sh

App=/export/App
Registry=${App}/registry
Logs=/export/Logs/

declare -A Configs
# logging to stderr means we get it in the systemd journal
REGISTRY_CONFIG=/export/Shell/registry/registry-config.yml
Configs[config]="${REGISTRY_CONFIG}"

################################################################################
#
#                           Functions
#
################################################################################

TARGET=${Registry}
func_service_template_1 $TARGET $Logs Configs $1
