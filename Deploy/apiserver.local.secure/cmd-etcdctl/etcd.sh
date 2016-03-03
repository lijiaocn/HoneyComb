#!/bin/bash

CMD=./bin/etcdctl
case $1 in
	(get)
		$CMD --peers http://etcd.local:2379 $* | python -m json.tool;;
	(*)
		$CMD --peers http://etcd.local:2379 $* ;;
esac
