#!/bin/bash

CMD=./bin/etcdctl
case $1 in
	(get)
		$CMD --peers http://etcd-proxy.local:2378 $* | python -m json.tool;;
	(*)
		$CMD --peers http://etcd-proxy.local:2378 $* ;;
esac
