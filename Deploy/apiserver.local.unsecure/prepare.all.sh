#!/bin/bash

#cp hosts /etc/
#cp hostname /etc/
for i in `ls -d */ |sed -e 's/\///' `
do
	echo "Prepare $i ..."
	cd $i;bash ./prepare.sh;cd ..
done
