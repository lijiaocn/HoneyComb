---
layout: default
title: Deploy-All-in-One-Unsecure

---

# Deploy-All-in-One-Unsecure
创建时间: 2016/02/01 11:39:50  修改时间: 2016/02/14 14:08:38 作者:lijiao

----

## 摘要

2016-02-14 14:08:34:

这是刚开始的部署一个“All in One”的unsecure的系统。这份文档诞生较早，其中部分内容已经不适用，以后也不打算更新这篇文档了。

## 部署配置

将编译得到的文件复制到目标机器的任意目录中(假设是/opt/unsecure)

	cp -rf  $GOPATH/src/github.com/lijiaocn/HoneyComb/Compile/out/*   /opt/unsecure

编写每个组件的配置文件, 每个组件配置配置都是和组件位于相同目录下的一个名为config的文件。如下:

	#tree /opt/unsecure/etcd/
	
	etcd
	├── config     <<--- etcd的配置文件
	├── etcd
	├── etcd.sh

在$GOPATH/src/github.com/lijiaocn/HoneyComb/Deploy/apiserver.local.unsecure中已经提供了All-in-One-Unsecure的配置文件。

	apiserver.local.unsecure/
	├── 1_etcd
	│   └── config
	├── 2_flannel
	│   ├── config
	│   ├── flannel.json
	│   └── net_init_config.sh
	├── 3_kube-apiserver
	│   └── config
	├── 4_kube-controller-manager
	│   └── config
	├── 5_kube-scheduler
	│   └── config
	├── 6_kubelet
	│   └── config
	├── 6_kube-proxy
	│   └── config
	├── 7_kubectl
	│   ├── config.yml
	│   ├── kubectl.sh
	│   └── unsecure
	│       └── kubeconfig.yml
	└── 8_registry
	    ├── config
	    └── config-example.yml

将配置文件复制到对应到目录中:

	cp 1_etcd/*      /opt/unsecure/etcd/
	cp 2_flannel/*   /opt/unsecure/flannel/
	...

配置Hosts:

	192.168.40.99 apiserver.local
	192.168.40.99 etcd.local
	192.168.40.99 registry.local

>192.168.40.99是笔者工作环境中的IP, 请修改为自己的工作环境中的IP。

因为kubernetes的一些配置项不能识别hostname, 因此还需要修改kubernetes组件的config文件的IP。

例如kube-apiserver/config中的配置项insecure-bind-address:

	CONFIGS[insecure-bind-address]='--insecure-bind-address=192.168.40.99'

## 启动组件

按照如下顺序启动组件:

	etcd --> flannel --> kube-apiserver --> kube-controller-manager 
	                                        kube-scheduler
	                                        kubelete
	                                        kube-proxy

启动方式以etcd为例:

	cd  /opt/unsecure/etcd
	./etcd.sh start     

>flannel在启动之前，需要先执行./net_init_config.sh, 在etcd中写入配置。

>一些组件需要有较高的运行的权限, 例如kubelet。

## 日志

启动后, 会在当前目录下生成log目录, 里面存放有程序的标准、错误输出以及操作记录:

	log/
	├── etcd.operate
	├── etcd.pid
	├── etcd.stderr
	├── etcd.stdout

## 文献
