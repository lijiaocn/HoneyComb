#!/bin/bash

. ../Shell/library.sh

PASSWORD=""
MACHINES_LST=""

install(){
	dish -e "curl -o /root/first_install.sh http://192.168.202.240/HoneyComb/first_install.sh && bash /root/first_install.sh" -g ${MACHINES_LST} -p ${PASSWORD}
}

start(){
	dish -e "cd /export/Shell && /bin/bash ./run.sh" -g ${MACHINES_LST} -p ${PASSWORD}
}

stop(){
	dish -e "cd /export/Shell && /bin/bash ./stop.sh" -g ${MACHINES_LST} -p ${PASSWORD}
}

update(){
	dish -e "cd /export/Shell && /bin/bash ./update.sh" -g ${MACHINES_LST} -p ${PASSWORD}
}

upload(){
	machines=`cat ./${MACHINES_LST} |grep -v "#"`
	for i in $machines
	do
		func_cmd_need_password $PASSWORD "scp -r $* $i:/root/upload/"
	done
}


if [[ ! $1 == "-c" ]];then
	echo "Usage: $0  -c ClusterDIR Commands"
	exit 1
fi
shift 1

MACHINES_LST="$1/machines.lst"
shift 1

func_secret_input PASSWORD "PASSWORD:"

case $1 in
	(start)
		start;;
	(stop)
		stop;;
	(update)
		update;;
	(install)
		install;;
	(upload)
		shift 1
		upload $* ;;
	(*)
		dish -e "$*" -g ${MACHINES_LST} -p ${PASSWORD}
esac
