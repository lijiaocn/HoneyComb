#!/bin/bash
. /export/Shell/config-global/base.sh
. /export/Shell/config-global/config
. /export/Shell/config-global/library.sh

App=/export/App
Logs=/export/Logs/
KubeManager=${App}/kube-controller-manager

declare -A Configs
# logging to stderr means we get it in the systemd journal
Configs[logtostderr]="--logtostderr=true"

# journal message level, 0 is debug
Configs[log_level]="--v=0"
Configs[kubeconf]="--kubeconfig=./kubeconfig.yml"

################################################################################
#
#                           decided by base.sh
#
################################################################################

# Comma separated list of minions
# Configs[master]="--master=${MASTER_SERVER}"

################################################################################
#
#                           Functions
#
################################################################################

TARGET=${KubeManager}
func_service_template_1 $TARGET $Logs Configs $1
