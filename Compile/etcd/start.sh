#!/bin/bash

MEMBER="LocalIP"
DATA="/export/DATA/etcd/dat/"
WAL="/export/DATA/etcd/wal/"
LISTEN_PEER="http://localhost:2380,http://localhost:7001"
LISTEN_CLIENT="http://localhost:2379,http://localhost:4001"
CORS=""
INITIAL="default=http://localhost:2380,default=http://localhost:7001"
STATE="new"  #existing
TOKEN="etcd-cluster"

if [ ! -d $DATA ];then
	mkdir -p $DATA
fi

if [ ! -d $WAL ];then
	mkdir -p $WAL
fi

etcd  \
	--name       ${MEMBER} \
	--data-dir   ${DATA} \
	--wal-dir    ${WAL}\
	--snapshot-count      '1000' \
	--heartbeat-interval  '100'  \
	--election-timeout    '100'  \
	--listen-peer-urls    $LISTEN_PEER   \
	--listen-client-urls  $LISTEN_CLIENT \
	-cors $CORS  \
	--initial-advertise-peer-urls $LISTEN_PEER \
	--initial-cluster  $INITIAL   \
	--initial-cluster-state $STATE  \
	--initial-cluster-token  $TOKEN \
	--advertise-client-urls  $LISTEN_CLIENT
