#!/bin/bash

REGISTRY_FILE=registry.tar.gz
docker save registry:latest |gzip >${REGISTRY_FILE}
