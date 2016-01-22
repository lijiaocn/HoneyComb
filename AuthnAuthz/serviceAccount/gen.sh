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

gen_client_ca
