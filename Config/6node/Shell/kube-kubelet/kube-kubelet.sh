#!/bin/bash

. /export/Shell/config-global/base.sh
. /export/Shell/config-global/config
. /export/Shell/config-global/library.sh

App=/export/App
Kubelet=${App}/kubelet
Logs=/export/Logs/

KUBELET_LISTEN=0.0.0.0
#HOSTNAME=`hostname`
HOSTNAME=`ip addr show flannel0 |grep inet |awk  '{print $2}'|sed "s/\/.*//"`

declare -A Configs
# logging to stderr means we get it in the systemd journal
Configs[logtostderr]="--logtostderr=true"
Configs[kubeconf]="--kubeconfig=./kubeconfig.yml"

# journal message level, 0 is debug
Configs[log_level]="--v=0"

# You may leave this blank to use the actual hostname
Configs[hostname-override]="--hostname-override=${HOSTNAME}"

# Should this cluster be allowed to run privileged docker containers
Configs[allow-privileged]="--allow-privileged=false"

#Configs[host-network-source]="--host-network-sources=*"

Configs[tls-cert-file]="--tls-cert-file=./cert-self/cert.pem"

Configs[tls-private-key-file]="--tls-private-key-file=./cert-self/key.pem"

################################################################################
#
#                           decided by base.sh
#
################################################################################

Configs[cluster-dns]="--cluster-dns=${CLUSTER_DNS}"
Configs[cluster-domain]="--cluster-domain=${CLUSTER_DOMAIN}"

# The address for the info server to serve on (set to 0.0.0.0 or "" for all interfaces)
Configs[address]="--address=${KUBELET_LISTEN}"

# The port for the info server to serve on
Configs[port]="--port=${KUBELET_PORT}"

# location of the api-server
Configs[api-servers]="--api-servers=${API_SERVERS}"

#Configs[pod-infra-container-image]="--pod-infra-container-image=docker.io/kubernetes/pause:latest"
Configs[pod-infra-container-image]="--pod-infra-container-image=${DOCKER_REGISTRYS}/kubernetes/pause:latest"

################################################################################
#
#                           Functions
#
################################################################################

TARGET=${Kubelet}
func_service_template_1 $TARGET $Logs Configs $1
