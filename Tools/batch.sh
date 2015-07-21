#!/bin/bash

. ./Shell/library.sh

PASSWORD=""

install(){
	dish -e "curl -o /root/first_install.sh http://192.168.202.240/HoneyComb/first_install.sh && bash /root/first_install.sh" -g machines.lst -p ${PASSWORD}
}

start(){
	dish -e "cd /export/Shell && /bin/bash ./run.sh" -g machines.lst -p ${PASSWORD}
}

stop(){
	dish -e "cd /export/Shell && /bin/bash ./stop.sh" -g machines.lst -p ${PASSWORD}
}

update(){
	dish -e "cd /export/Shell && /bin/bash ./update.sh" -g machines.lst -p ${PASSWORD}
}

upload(){
	machines=`cat ./machines.lst |grep -v "#"`
	for i in $machines
	do
		func_cmd_need_password $PASSWORD "scp -r $* $i:/root/upload/"
	done
}

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
		dish -e "$*" -g machines.lst -p ${PASSWORD}
esac
