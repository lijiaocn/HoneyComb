#!/bin/bash
if [ ! -d certs ];then
	mkdir certs
fi

cp -rf ../../../Compile/kubernetes/out/kube-controller-manager/* .

#cp ../../../AuthnAuthz/apiserver/ca/ca.pem            ./certs/apiserver.ca
#cp ../../../AuthnAuthz/serviceAccount/ca/ca-key.pem   ./certs/service.account.key
#cp ../../../AuthnAuthz/authn/output/kube-controller-manager/cert.pem  ./certs/authn.cert
#cp ../../../AuthnAuthz/authn/output/kube-controller-manager/key.pem   ./certs/authn.key
