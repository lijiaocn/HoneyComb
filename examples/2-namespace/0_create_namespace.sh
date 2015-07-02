#!/bin/bash
. ./common.sh

${Execute} create -f ./json/0_namespace.dev.json
${Execute} create -f ./json/0_namespace.prod.json
${Execute} get namespace

