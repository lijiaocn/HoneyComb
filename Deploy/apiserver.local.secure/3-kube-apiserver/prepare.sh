#!/bin/bash

if [ ! -d certs ];then
	mkdir certs
fi
cp -rf ../../../Compile/kubernetes/out/kube-apiserver/*   .
cp ../../../AuthnAuthz/apiserver/output/apiserver.local/cert.pem  ./certs/apiserver.local.cert
cp ../../../AuthnAuthz/apiserver/output/apiserver.local/key.pem   ./certs/apiserver.local.key

cp ../../../AuthnAuthz/kubelets/ca/ca.pem  ./certs/kubelet.ca
cp ../../../AuthnAuthz/kubelets/output/192.168.40.99/cert.pem  ./certs/apiserver.kubelet.cert
cp ../../../AuthnAuthz/kubelets/output/192.168.40.99/key.pem   ./certs/apiserver.kubelet.key

cp ../../../AuthnAuthz/authn/ca/ca.pem  ./certs/apiserver.auth.ca

cp ../../../AuthnAuthz/serviceAccount/ca/ca.pem  ./certs/service.account.cert

cp ../../../AuthnAuthz/authz/policy.json   .
