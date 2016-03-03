#!/bin/bash
. ./common.sh

${Execute} delete -f ./json/0_namespace.dev.json
${Execute} delete -f ./json/0_namespace.prod.json
${Execute} get namespace

