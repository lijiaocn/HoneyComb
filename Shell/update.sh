#!/bin/bash
/bin/cp -f ./library.sh /dev/shm/
/bin/cp -f ./update_op.sh /dev/shm
cd /dev/shm
bash ./update_op.sh
