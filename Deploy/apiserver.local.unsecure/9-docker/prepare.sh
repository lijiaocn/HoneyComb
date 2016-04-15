#!/bin/bash
if [ ! -d ./log ];then mkdir ./log; fi
if [ ! -d ./log/DockerDat ];then mkdir -p ./log/DockerData; fi

if [ ! -d certs ];then
	mkdir certs
fi
cp ../../../AuthnAuthz/registry/ca/ca.pem   ./certs
