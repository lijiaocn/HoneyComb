---
layout: default
title: Deploy

---

# Deploy
创建时间: 2016/02/03 17:56:59  修改时间: 2016/03/03 19:06:13 作者:lijiao

----

## 摘要

在前面的编译、证书制作等环节中，生成的文件都还位于各自出生时的目录中，需要将它们按照组件进行汇集。

## 汇集

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

prepare.sh会自动将相应的证书和程序复制到带有编号的子目录中，并准备相应的目录。

## 文献
