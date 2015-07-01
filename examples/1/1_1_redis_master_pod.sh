#!/bin/bash
. ./common.sh

${Execute}  create -f ./json/1_1_pod.redis_master.json
${Execute} get pods
