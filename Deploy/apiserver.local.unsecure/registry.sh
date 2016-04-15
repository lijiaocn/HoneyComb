#!/bin/bash

if [ ! $# -eq 1 ];then
	echo "Usage: $0 [start|stop|restart]"
	exit
fi

for i in 8-registry
do
	echo "============== $i =============="
	cmd=`echo ${i} |sed -e "s/.-//"`.sh
	cd $i; ./${cmd}  $1 ;cd ..
done
