#!/bin/bash 
Execute="../bin/kubectl --kubeconfig=./kubeconfig.yml"
${Execute} $*
