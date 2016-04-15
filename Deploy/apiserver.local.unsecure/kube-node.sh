#!/bin/bash

if [ ! $# -eq 1 ];then
	echo "Usage: $0 [start|stop|restart]"
	exit
fi

for i in A-etcd-proxy 2-flannel 6-kube-proxy 9-docker 7-kubelet
do
	echo "============== $i =============="
	cmd=`echo ${i} |sed -e "s/.-//"`.sh
	cd $i; ./${cmd}  $1 ;cd ..
done
