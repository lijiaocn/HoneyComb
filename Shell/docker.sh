#!/bin/bash

. ./library.sh
. ./base.sh

if [ "$1" == "start" ];then
	if [ ! -e /run/flannel/subnet.env ];then
		func_red_str "Flanneld must start before Docker!"
		exit 1
	fi
	source /run/flannel/subnet.env
fi

declare -A Configs
Configs[daemon]="--daemon=true"
Configs[debug]="--debug=true"
Configs[storage-driver]="--storage-driver=vfs"
################################################################################
#
#                           decided by base.sh
#
################################################################################
Configs[graph]="--graph=${DockerDat}"
Configs[bip]="--bip=$FLANNEL_SUBNET"
Configs[mtu]="--mtu=$FLANNEL_MTU"
#Api 1.18
#Configs[add-registry]="--add-registry=$DOCKER_REGISTRYS"
#Api 1.17
Configs[registry-mirror]="--registry-mirror=http://$DOCKER_REGISTRYS"
Configs[insecure-registry]="--insecure-registry=$DOCKER_INSECURES"
################################################################################
#
#                           Functions
#
################################################################################
if [ $1 == "stop" ];then
	ip link set docker0 down
	brctl delbr docker0
fi

#CentOS 6.4
if [ -e /etc/init.d/cgconfig ];then
	s=`service cgconfig status`
	if [ "$s" != "Running" ];then
		service cgconfig start
	fi
fi

TARGET=${Docker}
./cgroupfs-mount.sh
func_service_template_1 $TARGET $Logs Configs $1
