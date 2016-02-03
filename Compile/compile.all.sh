#!/bin/bash
RUNPATH=`pwd`

for i in `ls -d */ |sed -e 's/\///' |grep -v out`
do
	echo "######################   $i  ######################"
	cd $i; bash ./${i}.sh; cd $RUNPATH
done
