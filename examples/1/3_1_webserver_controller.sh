#!/bin/bash
. ./common.sh

${Execute}  create -f ./json/3_1_controller.webserver.json
${Execute} get rc
