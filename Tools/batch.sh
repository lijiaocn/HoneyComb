#!/bin/bash
#wget -O library.sh https://raw.githubusercontent.com/lijiaocn/LinuxShell/master/library.sh 2>/dev/null

. ./library.sh

PASSWORD=""
MACHINES_LST=""
MachinesFile=""

roles(){
	./dish -e "cd /export/apiserver.local.unsecure/ && /bin/bash ./role.sh $1" -g ${MACHINES_LST} -p ${PASSWORD}
}

#start(){
#	./dish -e "cd /export/Shell && /bin/bash ./start.sh" -g ${MACHINES_LST} -p ${PASSWORD}
#}
#
#stop(){
#	./dish -e "cd /export/Shell && /bin/bash ./stop.sh" -g ${MACHINES_LST} -p ${PASSWORD}
#}
#
#update(){
#	./dish -e "cd /export/Shell && /bin/bash ./update.sh" -g ${MACHINES_LST} -p ${PASSWORD}
#}

upload(){
	machines=`cat ./${MACHINES_LST} |grep -v "#"`
	for i in $machines
	do
		func_cmd_need_password $PASSWORD "scp -r $* $i:/root/upload/"
	done
}


if [[ ! $1 == "-f" ]];then
	func_yellow_str "`cd ./machines/; ls ;cd ../`"
	echo -n "Choose the machines.lst:"
	read MachinesFile
else 
	shift 1
	MachinesFile=$1
	shift 1
fi

MACHINES_LST="./machines/${MachinesFile}"
if [ ! -e ${MACHINES_LST} ];then
	func_red_str "Not found: ${MACHINES_LST}"
	exit
fi

func_secret_input PASSWORD "PASSWORD:"

case $1 in
	(start)
		roles start;;
	(stop)
		roles stop;;
	(update)
		update;;
	(upload)
		shift 1
		upload $* ;;
	(*)
		./dish -e "$*" -g ${MACHINES_LST} -p ${PASSWORD}
esac
