#!/bin/bash
cd 1-etcd
./etcd.sh stop
cd ..

cd 2-flannel
sudo ./flanneld.sh stop
cd ..

cd 3-kube-apiserver
sudo ./kube-apiserver.sh stop
cd ..

cd 4-kube-controller-manager
./kube-controller-manager.sh stop
cd ..

cd 5-kube-scheduler
./kube-scheduler.sh stop
cd ..

cd 6-kube-proxy
sudo ./kube-proxy.sh stop
cd ..

cd 7-kubelet
sudo ./kubelet.sh stop
cd ..

cd 8-registry
./registry.sh stop
cd ..

cd 9-docker
sudo ./docker.sh stop
cd ..
