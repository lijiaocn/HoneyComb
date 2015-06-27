#!/bin/bash

. ./library.sh
. ./base.sh

declare -A Configs
# logging to stderr means we get it in the systemd journal
Configs[logtostderr]="--logtostderr=true"

# journal message level, 0 is debug
Configs[log_level]="--v=0"

################################################################################
#
#                           decided by base.sh
#
################################################################################

# Comma separated list of minions
Configs[machines]="--machines=${NODE_SERVERS}"
Configs[master]="--master=${MASTER_SERVER}"

################################################################################
#
#                           Functions
#
################################################################################

TARGET=${KubeManager}
func_service_template_1 $TARGET $Logs Configs $1
