#!/bin/bash

echo "Are you sure?[Y/N]"
read CONFIRM
if [[ "$CONFIRM" != "Y" ]];then
	exit 0
fi
for dir in `ls ./kubelets`
do
	echo "deleting ./kubelets/${dir}"
	rm -rf ./kubelets/${dir}/*
done
rm -rf ./output
