#!/bin/bash
RUNPATH=`pwd`
OUTPUT=${RUNPATH}/out

if [ ! -d $OUTPUT ];then
	mkdir -p $OUTPUT
fi

for i in `ls -d */ |sed -e 's/\///' |grep -v out`
do
	echo "######################   $i  ######################"
	#cd $i; bash ${i}.sh; cp -rf ./out/* $OUTPUT/; cd $RUNPATH
done
