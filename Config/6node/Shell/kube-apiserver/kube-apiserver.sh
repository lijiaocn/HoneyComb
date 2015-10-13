#!/bin/bash

. /export/Shell/config-global/config
. /export/Shell/config-global/base.sh
. /export/Shell/config-global/library.sh

API_LISTEN_ADDRESS="0.0.0.0"
App=/export/App
Logs=/export/Logs/
Data=/export/Data/
KubeApiserver=${App}/kube-apiserver

declare -A Configs

# serviceAccount
Configs[service-account-key-file]="--service-account-key-file=./cert-serviceAccount/ca.pem"

# kubelet https
Configs[kubelet-https]="--kubelet-https=true"
Configs[kubelet-certificate-authority]="--kubelet-certificate-authority=./cert-kubelet/ca.pem"
Configs[kubelet-client-certificate]="--kubelet-client-certificate=./cert-kubelet/cert.pem"
Configs[kubelet-client-key]="--kubelet-client-key=./cert-kubelet/key.pem"

# api https
Configs[tls-cert-file]="--tls-cert-file=./cert-api/cert.pem"
Configs[tls-private-key-file]="--tls-private-key-file=./cert-api/key.pem"

# authn
Configs[client-ca-file]="--client-ca-file=./cert-authn/ca.pem"

# authz
Configs[authorization-mode]="--authorization-mode=ABAC"
Configs[authorization-policy-file]="--authorization-policy-file=./authz/policy.json"

# logging to stderr means we get it in the systemd journal
Configs[logtostderr]="--logtostderr=true"

# journal message level, 0 is debug
Configs[log_level]="--v=0"

# Should this cluster be allowed to run privileged docker containers
Configs[allow-privileged]="--allow-privileged=false"

# default admission control policies
#Configs[admission_control]="--admission_control=NamespaceAutoProvision,LimitRanger,SecurityContextDeny,ServiceAccount,ResourceQuota"
#Configs[admission-control]="--admission-control=NamespaceAutoProvision,LimitRanger,SecurityContextDeny,ResourceQuota"
Configs[admission_control]="--admission_control=NamespaceLifecycle,NamespaceExists,LimitRanger,SecurityContextDeny,ServiceAccount,ResourceQuota"


################################################################################
#
#                           decided by base.sh
#
################################################################################

# Address range to use for services
Configs[service-cluster-ip-range]="--service-cluster-ip-range=${SERVICE_ADDRESSES}"

# The address on the local server to listen to.
Configs[insecure-bind-address]="--insecure-bind-address=${API_LISTEN_ADDRESS}"
Configs[insecure-port]="--insecure-port=${API_PORT}"
Configs[secure-port]="--secure-port=${API_SECURE_PORT}"
Configs[bind-address]="--bind-address=${API_LISTEN_ADDRESS}"

# Comma separated list of nodes in the etcd cluster
Configs[etcd-servers]="--etcd-servers=${ETCD_SERVERS}"

# Port minions listen on
Configs[kubelet-port]="--kubelet-port=${KUBELET_PORT}"

################################################################################
#
#                           Functions
#
################################################################################

TARGET=${KubeApiserver}
func_service_template_1 $TARGET $Logs Configs $1
