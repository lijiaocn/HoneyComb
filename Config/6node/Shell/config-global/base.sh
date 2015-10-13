#!/bin/bash

. /export/Shell/config-global/library.sh

###################  Docker ####################

CLUSTER_DNS="192.168.183.59"
CLUSTER_DOMAIN="cluster.local"
DOCKER_REGISTRYS="192.168.183.59:5000"
DOCKER_INSECURES="0.0.0.0/0"

###################  Etcd   #####################

declare -a ARRAY_ETCD_NODES
ARRAY_ETCD_NODES[0]="192.168.183.59"
ARRAY_ETCD_NODES[1]="192.168.183.60"

ETCD_PORT="2379"
ETCD_PEER_PORT="2380"

etcd_initial_cluster(){
	local str=""
	for i in ${ARRAY_ETCD_NODES[@]}
	do
		if [ "$str" == "" ];then
			str="$i=http://$i:${ETCD_PEER_PORT}" 
		else
			str="$i=http://$i:${ETCD_PEER_PORT},$str" 
		fi
	done
	echo $str
	return 0
}
ETCD_INITIAL_CLUSTER=`etcd_initial_cluster`

ETCD_SERVERS=`func_join_array "," "http://" ARRAY_ETCD_NODES ":${ETCD_PORT}"`

####################  Flannel #####################

FLANNEL_PREFIX="flanneld"

####################  Apiserver ####################

MASTER_SERVER="https://192.168.183.59:6443"

SERVICE_ADDRESSES="172.16.0.0/16"
API_PORT="8080"
API_SECURE_PORT="6443"

declare  -a ARRAY_API_SERVER_NODES
ARRAY_API_SERVER_NODES[0]="192.168.183.59"
API_SERVERS=`func_join_array "," "https://" ARRAY_API_SERVER_NODES ":${API_SECURE_PORT}"`

####################   Kubelet  ######################

KUBELET_PORT="10250"

