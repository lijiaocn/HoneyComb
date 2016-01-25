#!/bin/bash

CMD=../Compile/etcd/out/etcdctl/etcdctl
case $1 in
	(get)
		$CMD --peers 127.0.0.1:2379 $* | python -m json.tool;;
	(*)
		$CMD --peers 127.0.0.1:2379 $* ;;
esac
