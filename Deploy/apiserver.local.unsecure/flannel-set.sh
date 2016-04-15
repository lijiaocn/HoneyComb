#!/bin/bash

if [ ! $# -eq 1 ];then
	echo "Usage: $0 [start|stop|restart]"
	exit
fi

for i in A-etcd-proxy
do
	echo "============== $i =============="
	cmd=`echo ${i} |sed -e "s/.-//"`.sh
	cd $i; ./${cmd}  $1 ;cd ..
done

if [ $1 == "start" ];then
	echo "============== net_init_config =============="
	cd 2-flannel; ./net_init_config.sh; cd ..
fi
