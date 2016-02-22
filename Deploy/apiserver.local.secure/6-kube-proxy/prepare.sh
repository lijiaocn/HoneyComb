#!/bin/bash

if [ ! -d certs ];then
	mkdir certs
fi
cp -rf ../../../Compile/kubernetes/out/kube-proxy/*    .
cp ../../../AuthnAuthz/apiserver/ca/ca.pem  ./certs/apiserver.ca
cp ../../../AuthnAuthz/authn/output/kube-proxy/cert.pem  ./certs/authn.cert
cp ../../../AuthnAuthz/authn/output/kube-proxy/key.pem   ./certs/authn.key
