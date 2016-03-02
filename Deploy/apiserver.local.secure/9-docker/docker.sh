#!/bin/bash
#wget -O library.sh https://raw.githubusercontent.com/lijiaocn/LinuxShell/master/library.sh
source /run/flannel/subnet.env
. ./config
. ./library.sh
#./cgroupfs-mount.sh
#service docker stop
func_service_template_1 'docker daemon' ./log  CONFIGS  $1

