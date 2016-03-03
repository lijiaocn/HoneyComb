#!/bin/bash

CMD=../Compile/etcd/out/etcdctl/etcdctl
case $1 in
	(get)
		$CMD --peers http://etcd.local:2379 $* | python -m json.tool;;
	(*)
		$CMD --peers http://etcd.local:2379 $* ;;
esac
