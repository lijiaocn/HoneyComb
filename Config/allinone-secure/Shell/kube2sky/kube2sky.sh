#!/bin/bash

. /export/Shell/config-global/base.sh
. /export/Shell/config-global/config
. /export/Shell/config-global/library.sh

App=/export/App
Kube2sky=${App}/kube2sky
Logs=/export/Logs/

declare -A Configs

################################################################################
#
#                           decided by base.sh
#
################################################################################

Configs[etcd-server]="-etcd-server=${ETCD_SERVERS}"
Configs[domain]="-domain=${CLUSTER_DOMAIN}"
Configs[kubecfg_file]="-kubecfg_file=./config.yml"
################################################################################
#
#                           Functions
#
################################################################################

TARGET=${Kube2sky}
func_service_template_1 $TARGET $Logs Configs $1
