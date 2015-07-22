#!/bin/bash

. ./base.sh
. ./library.sh

source ./config
declare -A Configs
if [[ ${K8sTag} == "v1.0.0" ]];then
	# logging to stderr means we get it in the systemd journal
	Configs[logtostderr]="--logtostderr=true"

	# journal message level, 0 is debug
	Configs[log_level]="--v=0"

	# Should this cluster be allowed to run privileged docker containers
	Configs[allow-privileged]="--allow-privileged=false"

	# default admission control policies
	#Configs[admission_control]="--admission_control=NamespaceAutoProvision,LimitRanger,SecurityContextDeny,ServiceAccount,ResourceQuota"
	Configs[admission-control]="--admission-control=NamespaceAutoProvision,LimitRanger,SecurityContextDeny,ResourceQuota"
fi
################################################################################
#
#                           decided by base.sh
#
################################################################################

if [[ ${K8sTag} == "v1.0.0" ]];then
	# Address range to use for services
	Configs[service-cluster-ip-range]="--service-cluster-ip-range=${SERVICE_ADDRESSES}"
	# The address on the local server to listen to.
	Configs[insecure-bind-address]="--insecure-bind-address=${API_LISTEN_ADDRESS}"
	Configs[bind-address]="--bind-address=${API_LISTEN_ADDRESS}"
	# The port on the local server to listen on.
	Configs[insecure-port]="--insecure-port=${API_PORT}"
	# Comma separated list of nodes in the etcd cluster
	Configs[etcd-servers]="--etcd-servers=${ETCD_SERVERS}"
	# Port minions listen on
	Configs[kubelet-port]="--kubelet-port=${KUBELET_PORT}"
fi

################################################################################
#
#                           Functions
#
################################################################################

TARGET=${KubeApiserver}
func_service_template_1 $TARGET $Logs Configs $1
