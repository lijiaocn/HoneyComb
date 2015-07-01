#!/bin/bash
. ./common.sh

${Execute}  create -f ./json/2_1_controller.redis_slave.json
${Execute} get rc
