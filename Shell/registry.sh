#!/bin/bash

. ./library.sh
. ./base.sh

source ./config

declare -A Configs
# logging to stderr means we get it in the systemd journal
Configs[config]="${REGISTRY_CONFIG}"

################################################################################
#
#                           Functions
#
################################################################################

TARGET=${Registry}
func_service_template_1 $TARGET $Logs Configs $1
