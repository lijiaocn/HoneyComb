#!/bin/bash

if [ ! $# -eq 1 ];then
	echo "Usage: $0 [start|stop|restart]"
	exit
fi

for i in A-etcd-proxy 4-kube-controller-manager
do
	cmd=`echo ${i} |sed -e "s/.-//"`.sh
	cd $i; ./${cmd}  $1 ;cd ..
done
