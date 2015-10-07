#!/bin/bash

#ADDR=127.0.0.1:5000/v2
ADDR=https://localhost:5000/v2
CURL_OPTIONS="-i"

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
