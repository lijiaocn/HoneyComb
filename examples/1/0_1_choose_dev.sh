#!/bin/bash
. ./common.sh

${Execute} config set-context dev --namespace=example-1-dev --cluster=virtualmachines --user=lijiao
${Execute} config view 
