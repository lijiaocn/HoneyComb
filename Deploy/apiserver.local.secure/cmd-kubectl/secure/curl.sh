#!/bin/bash

CA=../apiserver.ca
KEY=./Cert/key.pem
CERT=./Cert/cert.pem
VERSION=v1
APIHOST=https://apiserver.local
RESOURCE=$1
result=`curl  --cacert ${CA} --key ${KEY} --cert ${CERT} ${APIHOST}/api/${VERSION}/${RESOURCE} 2>/dev/null`

echo $result | python -m json.tool
echo "===================== RAW FORMAT =========================="
echo $result
