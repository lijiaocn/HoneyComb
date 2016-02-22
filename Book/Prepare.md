---
layout: default
title: Deploy

---

# Deploy
创建时间: 2016/02/03 17:56:59  修改时间: 2016/02/22 17:38:12 作者:lijiao

----

## 摘要

## 准备

在Deploy/apiserver.local.secure的子目录中依次执行prepare.sh。

	./Deploy/apiserver.local.secure/1-etcd/prepare.sh
	./Deploy/apiserver.local.secure/2-flannel/prepare.sh
	./Deploy/apiserver.local.secure/3-kube-apiserver/prepare.sh
	./Deploy/apiserver.local.secure/4-kube-controller-manager/prepare.sh
	./Deploy/apiserver.local.secure/5-kube-scheduler/prepare.sh
	./Deploy/apiserver.local.secure/6-kube-proxy/prepare.sh
	./Deploy/apiserver.local.secure/7-kubelet/prepare.sh
	./Deploy/apiserver.local.secure/8-registry/prepare.sh
	./Deploy/apiserver.local.secure/cmd-etcdctl/prepare.sh
	./Deploy/apiserver.local.secure/cmd-kubectl/prepare.sh

prepare.sh会自动将相应的证书和程序复制到带有编号的子目录中。

## 文献
