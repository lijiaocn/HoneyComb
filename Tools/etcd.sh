#!/bin/bash

case $1 in
	(get)
		/export/App/etcdctl --peers 127.0.0.1:2379 $* | python -m json.tool;;
	(*)
		/export/App/etcdctl --peers 127.0.0.1:2379 $* ;;
esac
