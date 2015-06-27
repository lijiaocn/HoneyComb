#!/bin/bash

. ./base.sh
. ./library.sh

declare -A Configs
# logging to stderr means we get it in the systemd journal
Configs[logtostderr]="--logtostderr=true"

# journal message level, 0 is debug
Configs[log_level]="--v=0"

# Should this cluster be allowed to run privileged docker containers
Configs[allow_privileged]="--allow_privileged=false"

# default admission control policies
#Configs[admission_control]="--admission_control=NamespaceAutoProvision,LimitRanger,SecurityContextDeny,ServiceAccount,ResourceQuota"
Configs[admission_control]="--admission_control=NamespaceAutoProvision,LimitRanger,SecurityContextDeny,ResourceQuota"

################################################################################
#
#                           decided by base.sh
#
################################################################################

# Comma separated list of nodes in the etcd cluster
Configs[etcd_servers]="--etcd_servers=${ETCD_SERVERS}"

# The address on the local server to listen to.
Configs[address]="--address=${API_LISTEN_ADDRESS}"

# The port on the local server to listen on.
Configs[port]="--port=${API_PORT}"

# Port minions listen on
Configs[kubelet_port]="--kubelet_port=${KUBELET_PORT}"

# Address range to use for services
Configs[portal_net]="--portal_net=${SERVICE_ADDRESSES}"

################################################################################
#
#                           Functions
#
################################################################################

TARGET=${KubeApiserver}
func_service_template_1 $TARGET $Logs Configs $1
