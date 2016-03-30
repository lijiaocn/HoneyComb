#!/bin/bash
if [ ! -d ./log ];then mkdir ./log; fi
if [ ! -d ./log/DockerDat ];then mkdir -p ./log/DockerData; fi

if [ ! -d certs ];then
	mkdir certs
fi

if [ ! -e /etc/docker/certs.d/registry.local:5000/ca.crt ];then
	sudo mkdir -p  /etc/docker/certs.d/registry.local:5000
	sudo cp -f ../../../AuthnAuthz/registry/ca/ca.pem  /etc/docker/certs.d/registry.local:5000/ca.crt
fi
