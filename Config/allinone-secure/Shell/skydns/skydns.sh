#!/bin/bash

. /export/Shell/config-global/base.sh
. /export/Shell/config-global/config
. /export/Shell/config-global/library.sh

App=/export/App
Skydns=${App}/skydns
Logs=/export/Logs/

declare -A Configs
Configs[addr]="-addr=127.0.0.1:53"

################################################################################
#
#                           decided by base.sh
#
################################################################################

Configs[machines]="-machines=${ETCD_SERVERS}"
Configs[domain]="-domain=${CLUSTER_DOMAIN}"

################################################################################
#
#                           Functions
#
################################################################################

TARGET=${Skydns}
func_service_template_1 $TARGET $Logs Configs $1
