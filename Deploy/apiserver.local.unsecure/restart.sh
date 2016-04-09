#!/bin/bash
cd 1-etcd
./etcd.sh restart
cd ..

cd ./A-etcd-proxy
./etcd-proxy.sh restart
cd ..

cd 2-flannel
#./net_init_config.sh 
sudo ./flanneld.sh restart
cd ..

cd 3-kube-apiserver
sudo ./kube-apiserver.sh restart
cd ..

cd 4-kube-controller-manager
./kube-controller-manager.sh restart
cd ..

cd 5-kube-scheduler
./kube-scheduler.sh restart
cd ..

cd 6-kube-proxy
sudo ./kube-proxy.sh restart
cd ..

cd 7-kubelet
sudo ./kubelet.sh restart
cd ..

cd 8-registry
./registry.sh restart
cd ..

cd 9-docker
sudo ./docker.sh restart
cd ..
