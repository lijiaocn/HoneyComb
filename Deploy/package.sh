#!/bin/bash
WORKPATH=`pwd`
OUTPUT=./out/

if [ ! -d ${OUTPUT} ]
then
	mkdir -p ${OUTPUT}
fi

cp -rf ./apiserver.local.unsecure   ${OUTPUT}
cd ${OUTPUT}
	find . -name log -type d -exec rm -rf {} +
	tar -czvf apiserver.local.unsecure.tar.gz ./apiserver.local.unsecure
cd $WORKPATH
