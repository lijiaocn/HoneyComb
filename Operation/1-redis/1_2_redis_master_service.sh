#!/bin/bash
. ./common.sh

${Execute} create -f ./json/1_2_service.redis_master.json
${Execute} get services
