#!/bin/bash

cp -rf ../../../Compile/kubernetes/out/kubectl/*     .

if [ ! -d secure ];then
	mkdir secure
fi

cp -rf ../../../AuthnAuthz/apiserver/ca/ca.pem   ./secure/apiserver.ca
cp -rf ../../../AuthnAuthz/authn/users/admin*    ./secure/
cp -rf ../../../AuthnAuthz/authn/users/user-*    ./secure/
