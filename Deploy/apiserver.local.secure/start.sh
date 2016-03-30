#!/bin/bash
cd 1-etcd
./etcd.sh start
cd ..

cd 2-flannel
#./net_init_config.sh 
sudo ./flanneld.sh start
cd ..

cd 3-kube-apiserver
sudo ./kube-apiserver.sh start
cd ..

cd 4-kube-controller-manager
./kube-controller-manager.sh start
cd ..

cd 5-kube-scheduler
./kube-scheduler.sh start
cd ..

cd 6-kube-proxy
sudo ./kube-proxy.sh start
cd ..

cd 7-kubelet
sudo ./kubelet.sh start
cd ..

cd 8-registry
./registry.sh start
cd ..

cd 9-docker
sudo ./docker.sh start
cd ..
