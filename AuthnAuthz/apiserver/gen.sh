#!/bin/bash
RUNPATH=`pwd`
RELY="github.com/lijiaocn/LinuxShell"
TAG="master"
go get $RELY 2>/dev/null
cd $GOPATH/src/$RELY; git pull;git checkout $TAG;cd $RUNPATH
source $GOPATH/src/$RELY/library.sh

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
	sed  -e "s/{COMMONNAME}/${name}/" $template >./req.config
	sed -i  -e "s/{SUBDIR}/${SUBDIR}/" ./req.config
}

#$1: apiserver directory
#$2: CA
#$3: CAKEY
#$4: OUTPUT
gen_apiserver_cert(){
	local CUR=`pwd`
	local KUBELETEDIR=$1
	local CA=$2
	local CAKEY=$3
	local OUTPUT=$4
	cd $KUBELETEDIR
		if [ ! -d ${SUBDIR} ];then
			mkdir ${SUBDIR}
		fi
		gen_req_config  ${ReqTmp} `basename ${KUBELETEDIR}`
		openssl req  -new  -nodes -out ./${SUBDIR}/ca.csr -config ./req.config
		openssl x509 -req -days 365 -in ./${SUBDIR}/ca.csr -CA $CA -CAkey $CAKEY -CAcreateserial -out ./${SUBDIR}/cert.pem  -extfile ./req.config -extensions v3_ca
		if [[ $? != 0 ]];then
			func_red_str "something is wrong."
			exit
		fi
	cd $CUR

	local outdir="${OUTPUT}/`basename ${KUBELETEDIR}`"
	if [ ! -d ${outdir} ];then
		mkdir -p ${outdir}
	fi
	cp -rf $KUBELETEDIR/${SUBDIR}/cert.pem ${outdir}/
	cp -rf $KUBELETEDIR/${SUBDIR}/key.pem ${outdir}/
	func_green_str "It's OK. "
	func_green_str "locate at: ${KUBELETEDIR}/${SUBDIR} and ${outdir}"
}

choose(){
	func_yellow_str "`ls ./apiservers/`"
	echo -n "Choose the apiserver:  "
	read KUBELETE

	KUBELETEDIR=./apiservers/${KUBELETE}

	if [ ! -d  ${KUBELETEDIR} ];then
		func_red_str "Not found directory ${KUBELETE} in ./apiservers"
		exit
	fi

	gen_apiserver_cert ${KUBELETEDIR} "`pwd`/${CA}" "`pwd`/${CAKEY}"  `pwd`/${OUTPUT}
}

gen_all(){
	for apiserver in `ls ./apiservers/`
	do
		func_yellow_str "Generate cert for apiservers/${apiserver}"
		gen_apiserver_cert ./apiservers/${apiserver} `pwd`/${CA} `pwd`/${CAKEY} `pwd`/${OUTPUT}
	done
}

choose_req_temp(){
	for i in `ls ./ReqTmp`
	do
		func_yellow_str $i
	done
	echo -n "Choose the req template:  "
	read ReqTmp
	ReqTmp="`pwd`/ReqTmp/${ReqTmp}"
	if [ ! -e ${ReqTmp} ];then
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

