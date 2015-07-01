#!/bin/bash
docker tag kubernetes/pause:latest  192.168.202.240:5000/kubernetes/pause:latest
docker push 192.168.202.240:5000/kubernetes/pause:latest
