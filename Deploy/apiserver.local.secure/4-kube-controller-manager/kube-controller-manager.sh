#!/bin/bash
#wget -O library.sh https://raw.githubusercontent.com/lijiaocn/LinuxShell/master/library.sh
. ./config
. ./library.sh
if [ ! -d ./log ];then mkdir ./log; fi
func_service_template_1 ./bin/kube-controller-manager ./log  CONFIGS  $1
