#!/bin/bash

#########################################################
#   deploy example: 
#   6 machines ,ip range 192.168.202.[241-246]
#   5 machines ,ip range 192.168.200.[164-168]

. ./library.sh

RUNDIR=/var/run/HoneyComb-K

ETCD_PORT="2379"
ETCD_PEER_PORT="2380"

KUBELET_LISTEN="0.0.0.0"
KUBELET_PORT="10250"

API_LISTEN_ADDRESS="0.0.0.0"
API_PORT="8080"

SERVICE_ADDRESSES="172.16.0.0/16"

FLANNEL_PREFIX="flanneld"

#docker
DOCKER_REGISTRYS="192.168.202.240:5000"
DOCKER_INSECURES="0.0.0.0/0"

#registry Nodes
ARRAY_REGISTRY_NODES[0]="192.168.202.240"

#etcd Nodes
declare -a ARRAY_ETCD_NODES
ARRAY_ETCD_NODES[0]="192.168.202.241"
ARRAY_ETCD_NODES[1]="192.168.202.242"

#kubernete ApiServer Nodes
declare  -a ARRAY_API_SERVER_NODES
ARRAY_API_SERVER_NODES[0]="192.168.183.59"

#kubernete controller manager Nodes
declare  -a ARRAY_MANAGER_NODES
ARRAY_MANAGER_NODES[0]="192.168.183.60"

#kubernete  scheduler Nodes
declare  -a ARRAY_SCHEDULER_NODES
ARRAY_SCHEDULER_NODES[0]="192.168.183.61"

#kubernete Nodes
declare  -a ARRAY_KUBE_NODES
ARRAY_KUBE_NODES[1]="192.168.183.62"
ARRAY_KUBE_NODES[2]="192.168.183.63"
ARRAY_KUBE_NODES[3]="192.168.183.64"
ARRAY_KUBE_NODES[4]="192.168.183.65"

#kubenetes master
#TODO
#It should be a api server list. but kubernete maybe haven't finish this work
MASTER_SERVER="http://192.168.183.59:8080"

App=/export/App
Logs=/export/Logs/
Data=/export/Data/
Shell=/export/Shell

EtcdDat=${Data}/etcd.dat
DockerDat=${Data}/docker.dat

KubeApiserver=${App}/kube-apiserver
KubeManager=${App}/kube-controller-manager
KubeProxy=${App}/kube-proxy
KubeScheduler=${App}/kube-scheduler
Kubectl=${App}/kubectl
Kubelet=${App}/kubelet
Flanneld=${App}/flanneld
Etcd=${App}/etcd
Registry=${App}/registry
Docker=/usr/bin/docker

#etcd addr  for client
#ETCD_ADDR="192.168.13.86:2379,192.168.13.87:2379"
ETCD_ADDR=`func_join_array "," "" ARRAY_ETCD_NODES ":${ETCD_PORT}"`

#etcd addrs  used by itself
#ETCD_PEERS="192.168.13.86:2379,192.168.13.87:2379"
ETCD_PEERS=`func_join_array "," "" ARRAY_ETCD_NODES ":${ETCD_PEER_PORT}"`

#etcd addrs for kubernete
#ETCD_SERVERS="http://192.168.13.86:2379"
ETCD_SERVERS=`func_join_array "," "http://" ARRAY_ETCD_NODES ":${ETCD_PORT}"`

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

#kubenetes nodes list
#NODE_SERVERS="192.168.13.93,192.168.13,87"
NODE_SERVERS=`func_join_array ","  "" ARRAY_KUBE_NODES ""`

#kubenetes apiserver list
#API_SERVER="http://192.168.13.86:8080"
API_SERVERS=`func_join_array "," "http://" ARRAY_API_SERVER_NODES ":${API_PORT}"`

