#!/bin/bash
docker tag kubernetes/pause:latest  registry.local:5000/kubernetes/pause:latest
docker push registry.local:5000/kubernetes/pause:latest
