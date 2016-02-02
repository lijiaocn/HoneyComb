#!/bin/bash

if [ ! -d certs ];then
	mkdir certs
fi
cp -rf ../../../Compile/kubernetes/out/kube-scheduler/*   .
cp ../../../AuthnAuthz/apiserver/ca/ca.pem  ./certs/apiserver.ca
cp ../../../AuthnAuthz/authn/output/kube-scheduler/cert.pem  ./certs/authn.cert
cp ../../../AuthnAuthz/authn/output/kube-scheduler/key.pem   ./certs/authn.key
