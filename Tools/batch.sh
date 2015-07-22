#!/bin/bash

. ../Shell/library.sh

PASSWORD=""
MACHINES_LST=""
Cluster=""

start(){
	./dish -e "cd /export/Shell && /bin/bash ./run.sh" -g ${MACHINES_LST} -p ${PASSWORD}
}

stop(){
	./dish -e "cd /export/Shell && /bin/bash ./stop.sh" -g ${MACHINES_LST} -p ${PASSWORD}
}

update(){
	./dish -e "cd /export/Shell && /bin/bash ./update.sh" -g ${MACHINES_LST} -p ${PASSWORD}
}

upload(){
	machines=`cat ./${MACHINES_LST} |grep -v "#"`
	for i in $machines
	do
		func_cmd_need_password $PASSWORD "scp -r $* $i:/root/upload/"
	done
}


if [[ ! $1 == "-c" ]];then
	func_yellow_str "`ls ../Config`"
	echo -n "Choose the Cluster:"
	read Cluster
else 
	shift 1
	Cluster=$1
	shift 1
fi

MACHINES_LST="../Config/$Cluster/machines.lst"
if [ ! -e ${MACHINES_LST} ];then
	func_red_str "Not found: ${MACHINES_LST}"
	exit
fi

func_secret_input PASSWORD "PASSWORD:"

case $1 in
	(start)
		start;;
	(stop)
		stop;;
	(update)
		update;;
	(upload)
		shift 1
		upload $* ;;
	(*)
		./dish -e "$*" -g ${MACHINES_LST} -p ${PASSWORD}
esac
