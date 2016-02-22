#!/bin/bash

echo "Are you sure?[Y/N]"
read CONFIRM
if [[ "$CONFIRM" != "Y" ]];then
	exit 0
fi
for dir in `ls ./registry`
do
	echo "deleting ./registry/${dir}"
	rm -rf ./registry/${dir}/*
done
rm -rf ./output
