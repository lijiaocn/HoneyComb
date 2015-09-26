#!/bin/bash

echo "Are you sure?[Y/N]"
read CONFIRM
if [[ "$CONFIRM" != "Y" ]];then
	echo "exit"
	exit 0
fi
for dir in `ls ./users`
do
	echo "deleting ./users/${dir}"
	rm -rf ./users/${dir}/*
done

rm -rf ./output
