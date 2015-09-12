#!/bin/bash 
#Execute="/export/App/kubectl -s 192.168.183.59:8080 "
Execute="/export/App/kubectl -s 127.0.0.1:8080 "
${Execute} $*
