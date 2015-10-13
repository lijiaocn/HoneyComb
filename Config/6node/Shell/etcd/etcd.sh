#!/bin/bash

. /export/Shell/config-global/base.sh
. /export/Shell/config-global/config
. /export/Shell/config-global/library.sh

ip_for_etcd(){
	for i in ${ARRAY_ETCD_NODES[@]}
	do
		for j in `func_ipv4_addr`
		do
			if [ "$i" == "$j" ];then
				echo $i
				return 0
			fi
		done
	done
}

App=/export/App
Etcd=${App}/etcd
Data=/export/Data/
EtcdDat=${Data}/etcd.dat
Logs=/export/Logs

IP_FOR_ETCD=`ip_for_etcd`

declare -A Configs

Configs[initial-cluster-token]="--initial-cluster-token etcd-cluster"
Configs[initial-cluster-state]="--initial-cluster-state new"
################################################################################
#
#                           decided by base.sh
#
################################################################################
Configs[data-dir]="--data-dir ${EtcdDat}"
Configs[name]="--name ${IP_FOR_ETCD}"
Configs[listen-peer-urls]="--listen-peer-urls  http://${IP_FOR_ETCD}:${ETCD_PEER_PORT}"
Configs[listen-client-urls]="--listen-client-urls http://${IP_FOR_ETCD}:${ETCD_PORT}"
Configs[advertise-client-urls]="--advertise-client-urls http://${IP_FOR_ETCD}:${ETCD_PORT}"
Configs[initial-advertise-peer-urls]="--initial-advertise-peer-urls http://${IP_FOR_ETCD}:${ETCD_PEER_PORT}"
Configs[initial-cluster]="--initial-cluster ${ETCD_INITIAL_CLUSTER}"

################################################################################
#
#                           Functions
#
################################################################################
TARGET=${Etcd}
func_service_template_1 $TARGET $Logs Configs $1

################################################################################
#
#                           Add Flannel Info Immediatly
#
################################################################################
FLANNEL_CONFIG=/export/Shell/etcd/flannel.json
if [ "$1" == "start" ];then
	func_yellow_str  "Deleting Flanneld old Config ..."
	ret=`curl http://${IP_FOR_ETCD}:${ETCD_PORT}/v2/keys/${FLANNEL_PREFIX}?recursive=true -XDELETE 2>/dev/null`
	func_red_str $ret

	func_yellow_str  "Putting Flanneld New Config ..."
	value=`cat ${FLANNEL_CONFIG}`
	ret=`curl http://${IP_FOR_ETCD}:${ETCD_PORT}/v2/keys/${FLANNEL_PREFIX}/config -XPUT -d value="$value" 2>/dev/null`
	func_green_str $ret
fi
