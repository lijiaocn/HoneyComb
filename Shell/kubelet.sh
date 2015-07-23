#!/bin/bash

. ./library.sh
. ./base.sh
source ./config

ip_for_kube(){
	for i in ${ARRAY_KUBE_NODES[@]}
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

declare -A Configs
# logging to stderr means we get it in the systemd journal
Configs[logtostderr]="--logtostderr=true"

# journal message level, 0 is debug
Configs[log_level]="--v=0"

if [[ ${K8sTag} == "v1.0.0" ]];then
	# You may leave this blank to use the actual hostname
	Configs[hostname-override]="--hostname-override=`ip_for_kube`"

	# Should this cluster be allowed to run privileged docker containers
	Configs[allow-privileged]="--allow-privileged=false"

	Configs[host-network-source]="--host-network-sources=*"
fi

################################################################################
#
#                           decided by base.sh
#
################################################################################

if [[ ${K8sTag} == "v1.0.0" ]];then
	# The address for the info server to serve on (set to 0.0.0.0 or "" for all interfaces)
	Configs[address]="--address=${KUBELET_LISTEN}"

	# The port for the info server to serve on
	Configs[port]="--port=${KUBELET_PORT}"

	# location of the api-server
	Configs[api-servers]="--api-servers=${API_SERVERS}"

	#Configs[pod-infra-container-image]="--pod-infra-container-image=docker.io/kubernetes/pause:latest"
	Configs[pod-infra-container-image]="--pod-infra-container-image=${DOCKER_REGISTRYS}/kubernetes/pause:latest"

fi
################################################################################
#
#                           Functions
#
################################################################################

TARGET=${Kubelet}
func_service_template_1 $TARGET $Logs Configs $1
