#!/bin/bash
#cd  image;make; cd ..

../../Tools/kubectl.sh  create -f ./kube-ui-rc.yaml
../../Tools/kubectl.sh  create -f ./kube-ui-svc.yaml

