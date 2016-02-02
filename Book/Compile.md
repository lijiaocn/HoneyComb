---
layout: default
title: Compile

---

# Compile
创建时间: 2016/02/01 11:12:56  修改时间: 2016/02/01 11:39:17 作者:lijiao

----

## 摘要

## 环境要求

	操作系统: Linux
	
	编译工具: Go
	
	依赖软件: godep, git

## 下载源码

	go get github.com/lijiaocn/HoneyComb

>源码将被下载到$GOPATH/src/github.com/lijiaocn/HoneyComb

## 编译

compile.all.sh将完成Compile目录下所有组件的编译, 将编译后得到程序统一存放在./out目录中。

	cd $GOPATH/src/github.com/lijiaocn/HoneyComb/Compile
	./compile.all.sh

>编译过程中会自动获取相应的源码。

编译完成后得到下面的文件:

	out/
	├── etcd
	│   ├── etcd
	│   └── etcd.sh
	├── etcdctl
	│   └── etcdctl
	├── flanneld
	│   ├── flanneld
	│   └── flanneld.sh
	├── kube-apiserver
	│   ├── kube-apiserver
	│   └── kube-apiserver.sh
	├── kube-controller-manager
	│   ├── kube-controller-manager
	│   └── kube-controller-manager.sh
	├── kubectl
	│   └── kubectl
	├── kubelet
	│   ├── kubelet
	│   └── kubelet.sh
	├── kube-proxy
	│   ├── kube-proxy
	│   └── kube-proxy.sh
	├── kube-scheduler
	│   ├── kube-scheduler
	│   └── kube-scheduler.sh
	├── registry
	│   ├── config
	│   ├── config-cache.yml
	│   ├── config-dev.yml
	│   ├── config-example.yml
	│   ├── registry
	│   └── registry.sh

如果要对组件进行单独编译, 只需要进入到对应的目录, 执行以组件名命名的脚本。例如要编译etcd:

	cd etcd
	./etcd.sh

得到etcd/out目录:

	out/
	├── etcd
	│   ├── etcd
	│   └── etcd.sh
	└── etcdctl
	    └── etcdctl

### More...

#### 如何执行要编译的版本?

以etcd为例, 编辑etcd/etcd.sh文件, 将TAG修改为要是用的版本。

	#!/bin/bash
	
	REPO="github.com/coreos/etcd"
	TAG="v2.2.4"
	PWD=`pwd`
	OUT=${PWD}/out/

## 文献
