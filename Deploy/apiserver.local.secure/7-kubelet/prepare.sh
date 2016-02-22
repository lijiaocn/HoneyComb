#!/bin/bash
if [ ! -d certs ];then
	mkdir certs
fi

cp -rf ../../../Compile/kubernetes/out/kubelet/*    .
cp ../../../AuthnAuthz/kubelets/output/kubelet.local/cert.pem  ./certs/kubelet.local.cert
cp ../../../AuthnAuthz/kubelets/output/kubelet.local/key.pem   ./certs/kubelet.local.key

cp ../../../AuthnAuthz/apiserver/ca/ca.pem  ./certs/apiserver.ca
cp ../../../AuthnAuthz/authn/output/kube-kubelet/cert.pem ./certs/authn.cert
cp ../../../AuthnAuthz/authn/output/kube-kubelet/key.pem  ./certs/authn.key
