#!/bin/bash

CURPATH=`pwd`

declare -a TARGETS
TARGETS=(
	"${CURPATH}/namespace.yaml"
	"${CURPATH}/1_influxdb_and_grafana/grafana-service.yaml"
	"${CURPATH}/1_influxdb_and_grafana/influxdb-grafana-controller.yaml"
	"${CURPATH}/1_influxdb_and_grafana/influxdb-service.yaml"
	"${CURPATH}/2_heapster/heapster-controller.yaml"
	"${CURPATH}/2_heapster/heapster-service.yaml"
	"${CURPATH}/3_kubedash/kube-config.yaml"
)
create(){
	cd ../../kube-cli/unsecure/
	for i in ${TARGETS[@]}
	do
		../kubectl.sh create -f $i
	done
}

delete(){
	cd ../../kube-cli/unsecure/
	for i in ${TARGETS[0]}
	do
		../kubectl.sh delete -f $i
	done
}

case $1 in
	(create)
		create;;
	(delete)
		delete;;
	(*)
		echo "usage: $0 [create|delete]"
esac
