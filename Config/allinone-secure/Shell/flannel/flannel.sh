#!/bin/bash

. /export/Shell/config-global/base.sh
. /export/Shell/config-global/config
. /export/Shell/config-global/library.sh

App=/export/App
Flanneld=${App}/flanneld
Logs=/export/Logs/

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
