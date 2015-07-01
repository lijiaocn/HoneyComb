#!/bin/bash
. ./common.sh

${Execute} create -f ./json/2_2_service.redis_slave.json
${Execute} get services
