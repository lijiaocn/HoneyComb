#!/bin/bash

. /export/Shell/config-global/base.sh
. /export/Shell/config-global/config
. /export/Shell/config-global/library.sh

App=/export/App
KubeScheduler=${App}/kube-scheduler
Logs=/export/Logs/

# logging to stderr means we get it in the systemd journal
Configs[logtostderr]="--logtostderr=true"

# journal message level, 0 is debug
Configs[log_level]="--v=0"

Configs[kubeconfig]="--kubeconfig=./kubeconfig.yml"

################################################################################
#
#                           decided by base.sh
#
################################################################################

# Comma separated list of minions
#Configs[master]="--master=${MASTER_SERVER}"

################################################################################
#
#                           Functions
#
################################################################################

TARGET=${KubeScheduler}
func_service_template_1 $TARGET $Logs Configs $1
