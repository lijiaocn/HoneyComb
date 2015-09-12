#!/bin/bash

. ../../Shell/library.sh

CA=./CA/ca.pem
CAKEY=./CA/ca-key.pem

gen_ca(){
	local CAPATH=./CA
	if [ ! -d ${CAPATH} ];then
		mkdir -p ${CAPATH}
	fi
	openssl req  -nodes -new -x509 -days 365 -keyout ${CAPATH}/ca-key.pem -out ${CAPATH}/ca.pem
}

#$1: user directory
#$3: CA
#$4: CAKEY
gen_user_cert(){
	local CUR=`pwd`
	local USERDIR=$1
	local CA=$2
	local CAKEY=$3
	if [ ! -e ${USERDIR}/req.config ];then
		func_red_str "Not Found ${USERDIR}/req.config"
		exit
	fi
	cd $USERDIR
		if [ ! -d out ];then
			mkdir out
		fi
		openssl req -new  -out ./out/ca.csr -config ./req.config
		openssl x509 -req -days 365 -in ./out/ca.csr -CA $CA -CAkey $CAKEY -CAcreateserial -out ./out/cert.pem
		if [[ $? != 0 ]];then
			func_red_str "something is wrong."
			exit
		fi
	cd $CUR
	func_green_str "It's OK. "
	func_green_str "locate at: ${USERDIR}/out"
	func_green_str "\t"`ls  ${USERDIR}/out`
}

choose(){
	func_yellow_str "`ls ./users/`"
	echo -n "Choose the user:"
	read USER

	USERDIR=./users/${USER}

	if [ ! -d  ${USERDIR} ];then
		func_red_str "Not found directory ${USER} in ./users"
		exit
	fi

	gen_user_cert ${USERDIR} `pwd`/${CA} `pwd`/${CAKEY}
}

gen_all(){

	for user in `ls ./users/`
	do
		func_green_str "./users/${user}: "
		gen_user_cert ./users/${user} `pwd`/${CA} `pwd`/${CAKEY}
	done
}

if [[ ! -e ${CA} || ! -e ${CAKEY} ]];then
	func_red_str "$CA or $CAKEY doesn't exist, generate a new ca?[Y|N]"
	read choose
	case $choose in
		(Y) gen_ca;;
		(N) exit;;
		(*) func_red_str "Your choose is wrong!"; exit;;
	esac
fi

func_yellow_str "Generat All?[Y|N]"
read GENALL

case $GENALL in
	(Y)gen_all;;
	(N)choose;;
	(*) func_red_str "Your choose is wrong!"; exit;;
esac

