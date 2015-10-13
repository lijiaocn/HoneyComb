#!/bin/bash

echo "Are you sure?[Y/N]"
read CONFIRM
if [[ "$CONFIRM" != "Y" ]];then
	exit 0
fi
rm -rf ./output
