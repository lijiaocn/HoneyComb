#!/bin/bash

. ./library.sh
. ./base.sh

declare -A Configs
Configs[iface]="-iface=eth0"

################################################################################
#
#                           decided by base.sh
#
################################################################################

Configs[etcd-endpoints]="-etcd-endpoints=${ETCD_SERVERS}"
Configs[etcd-prefix]="-etcd-prefix=${FLANNEL_PREFIX}"

################################################################################
#
#                           Functions
#
################################################################################

TARGET=${Flanneld}
func_service_template_1 $TARGET $Logs Configs $1
