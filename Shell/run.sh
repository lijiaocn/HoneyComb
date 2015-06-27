#!/bin/bash
. ./library.sh
. ./base.sh

ips=`func_ipv4_addr`

if [ ! -e ${RUNDIR} ];then
	mkdir -p $RUNDIR
fi

start_etcd=0
start_flanneld=1
start_apiserver=0
start_manager=0
start_scheduler=0
start_kubelet=0
start_kubeproxy=0
start_docker=0

for ip in $ips
do
	func_in_array $ip  ARRAY_ETCD_NODES
	if [ $? == 0 ];then
		start_etcd=1
	fi

	func_in_array $ip ARRAY_API_SERVER_NODES
	if [ $? == 0 ];then
		start_apiserver=1
	fi

	func_in_array $ip ARRAY_KUBE_NODES
	if [ $? == 0 ];then
		start_kubelet=1
		start_kubeproxy=1
		start_flanneld=1
		start_docker=1
	fi

	func_in_array $ip ARRAY_MANAGER_NODES
	if [ $? == 0 ];then
		start_manager=1
	fi

	func_in_array $ip ARRAY_SCHEDULER_NODES
	if [ $? == 0 ];then
		start_scheduler=1
	fi
done

if [ $start_etcd -eq 1 ];then
	./etcd.sh start
	touch ${RUNDIR}/etcd.sh
fi

if [ $start_flanneld -eq 1 ];then
	./flanneld.sh start
	touch ${RUNDIR}/flanneld.sh
fi

if [ $start_docker -eq 1 ];then
	./docker.sh start
	touch ${RUNDIR}/docker.sh
fi

if [ $start_apiserver -eq 1 ];then
	./apiserver.sh start
	touch ${RUNDIR}/apiserver.sh
fi

if [ $start_manager -eq 1 ];then
	./manager.sh start
	touch ${RUNDIR}/manager.sh
fi

if [ $start_scheduler -eq 1 ];then
	./scheduler.sh start
	touch ${RUNDIR}/scheduler.sh
fi

if [ $start_kubelet -eq 1 ];then
	./kubelet.sh start
	touch ${RUNDIR}/kubelet.sh
fi

if [ $start_kubeproxy -eq 1 ];then
	./kube-proxy.sh start
	touch ${RUNDIR}/kube-proxy.sh
fi
