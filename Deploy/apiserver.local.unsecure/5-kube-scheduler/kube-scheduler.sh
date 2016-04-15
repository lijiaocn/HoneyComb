#!/bin/bash
wget -O library.sh https://raw.githubusercontent.com/lijiaocn/LinuxShell/master/library.sh 2>/dev/null
. ./config
. ./library.sh
if [ ! -d ./log ];then mkdir ./log; fi
func_service_template_1 ./bin/kube-scheduler ./log  CONFIGS  $1
