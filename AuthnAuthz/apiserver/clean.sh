#!/bin/bash

echo "Are you sure?[Y/N]"
read CONFIRM
if [[ "$CONFIRM" != "Y" ]];then
	exit 0
fi
for dir in `ls ./apiservers`
do
	echo "deleting ./apiservers/${dir}"
	rm -rf ./apiservers/${dir}/*
done
rm -rf ./output
