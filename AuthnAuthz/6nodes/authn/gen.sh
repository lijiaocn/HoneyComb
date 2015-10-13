#!/bin/bash

. ../../../Shell/library.sh

SUBDIR=Cert
CLIENTCA=./ca

CA=${CLIENTCA}/ca.pem
CAKEY=${CLIENTCA}/ca-key.pem

OUTPUT=./output

ReqTmp=""

CAISNEW="false"

gen_client_ca(){
	if [ ! -d ${CLIENTCA} ];then
		mkdir -p ${CLIENTCA}
	fi
	openssl req  -nodes -new -x509 -days 365 -keyout ${CAKEY} -out ${CA}
	local capath="${OUTPUT}/`basename ${CLIENTCA}`"
	if [ ! -d ${capath} ];then
		mkdir -p ${capath}
	fi
	cp -rf ${CAKEY}  ${capath}/
	cp -rf ${CA}     ${capath}/
}

#$1: req.template
#$2: common name
gen_req_config(){
	local template=$1
	local name=$2
	sed -e "s/{COMMONNAME}/${name}/" $template >./req.config
	sed -i  -e "s/{SUBDIR}/${SUBDIR}/" ./req.config
}

#$1: user directory
#$2: CA
#$3: CAKEY
#$4: OUTPUT
gen_user_cert(){
	local CUR=`pwd`
	local USERDIR=$1
	local CA=$2
	local CAKEY=$3
	local OUTPUT=$4
	cd $USERDIR
		if [ ! -d ${SUBDIR} ];then
			mkdir ${SUBDIR}
		fi
		gen_req_config  ../../ReqTmp/${ReqTmp} `basename ${USERDIR}`
		openssl req  -new  -nodes -out ./${SUBDIR}/ca.csr -config ./req.config
		openssl x509 -req -days 365 -in ./${SUBDIR}/ca.csr -CA $CA -CAkey $CAKEY -CAcreateserial -out ./${SUBDIR}/cert.pem
		if [[ $? != 0 ]];then
			func_red_str "something is wrong."
			exit
		fi
	cd $CUR

	local outdir="${OUTPUT}/`basename ${USERDIR}`"
	if [ ! -d ${outdir} ];then
		mkdir -p ${outdir}
	fi
	cp -rf $USERDIR/${SUBDIR}/cert.pem ${outdir}/
	cp -rf $USERDIR/${SUBDIR}/key.pem ${outdir}/
	func_green_str "It's OK. "
	func_green_str "locate at: ${USERDIR}/${SUBDIR} and ${outdir}"
}

choose(){
	func_yellow_str "`ls ./users/`"
	echo -n "Choose the user:  "
	read USER

	USERDIR=./users/${USER}

	if [ ! -d  ${USERDIR} ];then
		func_red_str "Not found directory ${USER} in ./users"
		exit
	fi

	gen_user_cert ${USERDIR} "`pwd`/${CA}" "`pwd`/${CAKEY}"  `pwd`/${OUTPUT}
}

gen_all(){
	for user in `ls ./users/`
	do
		func_yellow_str "Generate cert for users/${user}"
		gen_user_cert ./users/${user} `pwd`/${CA} `pwd`/${CAKEY} `pwd`/${OUTPUT}
	done
}

choose_req_temp(){
	for i in `ls ./ReqTmp`
	do
		func_yellow_str $i
	done
	echo -n "Choose the req template:  "
	read ReqTmp
	if [ ! -e ./ReqTmp/${ReqTmp} ];then
		func_red_str "${ReqTmp} doesn't exist!" 
		exit
	fi
}

if [[ ! -e ${CA} || ! -e ${CAKEY} ]];then
	func_red_str "$CA or $CAKEY doesn't exist, generate a new ca?(will auto gen all certs)[Y|N]"
	read choose
	case $choose in
		(Y) gen_client_ca;CAISNEW="true";;
		(N) exit;;
		(*) func_red_str "Your choose is wrong!"; exit;;
	esac
fi


if [[ ${CAISNEW} == "false" ]] ;then
	echo -n "Generat All?[Y|N]:  "
	read GENALL
	choose_req_temp
	case $GENALL in
		(Y)gen_all;;
		(N)choose;;
		(*)func_red_str "Your choose is wrong!"; exit;;
	esac
else
	choose_req_temp
	gen_all
fi

