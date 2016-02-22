#!/bin/bash
if [ ! -d certs ];then
	mkdir certs
fi
if [ ! -d Data/registry ];then
	mkdir -p Data/registry
fi
cp -rf ../../../AuthnAuthz/registry/output/registry.local  ./certs/
cp -rf ../../../Compile/registry/out/registry/*  .
