#!/bin/bash
wget -O library.sh https://raw.githubusercontent.com/lijiaocn/LinuxShell/master/library.sh 2>/dev/null
source /run/flannel/subnet.env
. ./config
. ./library.sh
#./cgroupfs-mount.sh
service docker stop

if [ ! -e /etc/docker/certs.d/registry.local:5000/ca.crt ];then
	mkdir -p  /etc/docker/certs.d/registry.local:5000
fi
cp -f ./certs/ca.pem  /etc/docker/certs.d/registry.local:5000/ca.crt

if [ ! -d ./log ];then mkdir ./log; fi
func_service_template_1 'docker daemon' ./log  CONFIGS  $1

