#!/bin/bash
IP_FOR_ETCD=localhost
ETCD_PORT=2379
FLANNEL_PREFIX=kubernetes/network/flannel
FLANNEL_CONFIG=./flannel.json
#ret=`curl http://${IP_FOR_ETCD}:${ETCD_PORT}/v2/keys/${FLANNEL_PREFIX}?recursive=true -XDELETE 2>/dev/null`
value=`cat ${FLANNEL_CONFIG}`
curl http://${IP_FOR_ETCD}:${ETCD_PORT}/v2/keys/${FLANNEL_PREFIX}/config -XPUT -d value="$value"
