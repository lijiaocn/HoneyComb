#!/bin/bash

ADDR=https://registry.local:5000/v2
#CURL_OPTIONS="-i --insecure"
CURL_OPTIONS=" --insecure"

repo(){
	curl $CURL_OPTIONS  $ADDR/_catalog
}

#$1: repo name
tags(){
	curl $CURL_OPTIONS $ADDR/$1/tags/list
}

usage(){
	echo "repo            show repositories"
	echo "tags reponame   show repository's tags"
}

case $1 in
	(repo)  repo;;
	(tags)  shift 1; tags $1;;
	(-h)    usage;;
	(*)     usage;;
esac
