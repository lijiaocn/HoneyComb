#!/bin/bash

if [ ! $# -eq 1 ];then
	echo "Usage: $0 [start|stop|restart]"
	exit
fi

./all-in-one.sh  $1
#./registry.sh  $1
#./etcd-member.sh  $1
#./flannel-set.sh  $1
#./kube-apiserver.sh  $1
#./kube-controller-manager.sh  $1
#./kube-scheduler.sh  $1
#./kube-node.sh  $1
#./flannel-node.sh $1
