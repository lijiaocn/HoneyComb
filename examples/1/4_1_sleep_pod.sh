#!/bin/bash
. ./common.sh

${Execute} create -f ./json/4_1_sleep.json
${Execute} get pods
