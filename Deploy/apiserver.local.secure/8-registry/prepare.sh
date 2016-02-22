#!/bin/bash
if [ ! -d certs ];then
	mkdir certs
fi
if [ ! -d log/Data/registry ];then
	mkdir -p log/Data/registry
fi
cp -rf ../../../AuthnAuthz/registry/output/registry.local  ./certs/
cp -rf ../../../Compile/registry/out/registry/*  .
