---
layout: default
title: 0_release_0.0.1

---

# 0_release_0.0.1

创建时间: 2015/06/26 12:35:00  修改时间: 2015/07/23 14:00:23 作者:lijiao

----

## 摘要

这里介绍下HoneyComb中是如何编排集群,并进行统一部署。

每一节开始处的v0.0.1表示后续的内容适用于版本v0.0.1。

本文档只关注HoneyComb如何使用, 不会涉及到HoneyComb是如何实现的等内容。

(0.0.1版本中, HoneyComb自身的内容全部是Shell脚本, 所以待后续放出源码后，一切了然)

## 拓扑

v0.0.1

>注意: 下面的部署拓扑图只是示例中使用的拓扑, 不代表生产环境中部署方式(我对各种规模的集群的部署、容灾、网络规划等均不了解, 不曾实际参与过建设实施, 憾事一件...)。

![pic_0_1_Kubeneters-Deploy](./pic/pic_0_1_Kubeneters-Deploy.png)

机器角色:

	192.168.202.240   1. 编译HoneyComb涉及的开源项目的代码，打包HoneyComb程序。
	                  2. 私有的Docker Register: 192.168.202.240:5000。
	                  3. 提供HoneyComb发布包的下载服务。
	                  4. 用于执行一些管理操作。
	
	192.168.202.241   1. Etcd节点1

	192.168.202.242   2. Etcd节点2

	192.168.202.243   1. Kubernetes的ApiServer1

	192.168.202.244   1. Kubernetes的ApiServer2

	192.168.202.245   1. Kubernetes的Controller Manager

	192.168.202.246   1. Kubernetes的Scheduler

	192.168.200.164   1. Kubernetes的Node
	192.168.200.165   1. Kubernetes的Node
	192.168.200.166   1. Kubernetes的Node
	192.168.200.167   1. Kubernetes的Node
	192.168.200.168   1. Kubernetes的Node

## 编排

v0.0.1

在HoneyComb的v0.0.1中, 集群的编排工作在脚本Shell/base.sh中完成, 这个脚本中详细描述了每个机器的角色, 约定了各项服务的端口。

	#!/bin/bash

	#########################################################
	#   deploy example: 
	#   6 machines ,ip range 192.168.202.[241-246]
		#   5 machines ,ip range 192.168.200.[164-168]

	. ./library.sh

	RUNDIR=/var/run/HoneyComb-K

	ETCD_PORT="2379"
	ETCD_PEER_PORT="2380"

	KUBELET_LISTEN="0.0.0.0"
	KUBELET_PORT="10250"

	API_LISTEN_ADDRESS="0.0.0.0"
	API_PORT="8080"

	SERVICE_ADDRESSES="172.16.0.0/16"

	FLANNEL_PREFIX="flanneld"

	#docker
	DOCKER_REGISTRYS="192.168.202.240:5000"
	DOCKER_INSECURES="0.0.0.0/0"

	#etcd Nodes
	declare -a ARRAY_ETCD_NODES
	ARRAY_ETCD_NODES[0]="192.168.202.241"
	ARRAY_ETCD_NODES[1]="192.168.202.242"

	#kubernete ApiServer Nodes
	declare  -a ARRAY_API_SERVER_NODES
	ARRAY_API_SERVER_NODES[0]="192.168.202.243"
	ARRAY_API_SERVER_NODES[1]="192.168.202.244"

	#kubernete controller manager Nodes
	declare  -a ARRAY_MANAGER_NODES
	ARRAY_MANAGER_NODES[0]="192.168.202.245"

	#kubernete  scheduler Nodes
	declare  -a ARRAY_SCHEDULER_NODES
	ARRAY_SCHEDULER_NODES[0]="192.168.202.246"

	#kubernete Nodes
	declare  -a ARRAY_KUBE_NODES
	ARRAY_KUBE_NODES[1]="192.168.200.164"
	ARRAY_KUBE_NODES[2]="192.168.200.165"
	ARRAY_KUBE_NODES[3]="192.168.200.166"
	ARRAY_KUBE_NODES[4]="192.168.200.167"
	ARRAY_KUBE_NODES[5]="192.168.200.168"

	#kubenetes master
	#TODO
	#It should be a api server list. but kubernete maybe haven't finish this work
	MASTER_SERVER="http://192.168.202.243:8080"

	App=/export/App
	Logs=/export/Logs/
	Data=/export/Data/
	Shell=/export/Shell

	EtcdDat=${Data}/etcd.dat
	DockerDat=${Data}/docker.dat

	KubeApiserver=${App}/kube-apiserver
	KubeManager=${App}/kube-controller-manager
	KubeProxy=${App}/kube-proxy
	KubeScheduler=${App}/kube-scheduler
	Kubectl=${App}/kubectl
	Kubelet=${App}/kubelet
	Flanneld=${App}/flanneld
	Etcd=${App}/etcd
	Docker=/usr/bin/docker

	#etcd addr  for client
	#ETCD_ADDR="192.168.13.86:2379,192.168.13.87:2379"
	ETCD_ADDR=`func_join_array "," "" ARRAY_ETCD_NODES ":${ETCD_PORT}"`

	#etcd addrs  used by itself
	#ETCD_PEERS="192.168.13.86:2379,192.168.13.87:2379"
	ETCD_PEERS=`func_join_array "," "" ARRAY_ETCD_NODES ":${ETCD_PEER_PORT}"`

	#etcd addrs for kubernete
	#ETCD_SERVERS="http://192.168.13.86:2379"
	ETCD_SERVERS=`func_join_array "," "http://" ARRAY_ETCD_NODES ":${ETCD_PORT}"`

	etcd_initial_cluster(){
		local str=""
		for i in ${ARRAY_ETCD_NODES[@]}
		do
			if [ "$str" == "" ];then
				str="$i=http://$i:${ETCD_PEER_PORT}" 
			else
				str="$i=http://$i:${ETCD_PEER_PORT},$str" 
			fi
		done
		echo $str
		return 0
	}
	ETCD_INITIAL_CLUSTER=`etcd_initial_cluster`

	#kubenetes nodes list
	#NODE_SERVERS="192.168.13.93,192.168.13,87"
	NODE_SERVERS=`func_join_array ","  "" ARRAY_KUBE_NODES ""`

	#kubenetes apiserver list
	#API_SERVER="http://192.168.13.86:8080"
	API_SERVERS=`func_join_array "," "http://" ARRAY_API_SERVER_NODES ":${API_PORT}"`

## Flannel规划

v0.0.1

Flannel是一个开源的SDN项目。HoneyComb的0.0.1版本中使用了Flannel。

在Shell/flannel.json中进行Flannel的设置。

	{
		"Network":"172.16.0.0/16",
		"Subnetlen":24,
		"SubnetMin":"172.16.100.100",
		"SubnetMax":"172.16.254.254",
		"Backend":{
			"Type":"udp",
			"Port":7890
		}
	}

## 编译打包

v0.0.1

>注意运行gen.sh的机器上需要安装有Go, 且版本为1.1以上。

脚本gen.sh运行时会从github上下载相关项目(kubernetes、flannel、etcd)的源码, 然后将指定的版本编译后得到文件打包。

gen.sh中指定的项目地址与版本:

	#关联项目 Kubernetes
	Kubernetes_Url="https://github.com/GoogleCloudPlatform/kubernetes.git"
	Kubernetes_Dir="Kubernetes"
	Kubernetes_Tag="v0.18.2"

	#关联项目 flannel
	Flannel_Url="https://github.com/coreos/flannel.git"
	Flannel_Dir="Flannel"
	Flannel_Tag="v0.4.1"

	#关联项目 etcd
	Etcd_Url="https://github.com/coreos/etcd.git"
	Etcd_Dir="Etcd"
	Etcd_Tag="v2.0.11"

gen.sh运行时会从version文件中读取一个版本号,作为本次编译得到的发布包的版本。

	0.0.1

gen.sh运行结束后将得到一个名为FinalPackage的目录,HoneyComb发布包被存放在这里。

	FinalPackage/
	|-- 0.0.1                  --- 版本v0.0.1
	|   |-- base.sh
	|   |-- base_version
	|   |-- export.tar.gz
	|   `-- export_version
	|-- first_install.sh
	`-- lastest                --- 最新版本
		|-- base.sh
		|-- base_version
		|-- export.tar.gz
		`-- export_version

将FinalPackage中的内容直接复制到一个WebServer的目录中后, 可以直接使用first_install.sh脚本完成首次安装。

在我自己的环境将发布包拷贝到了192.168.202.240的Web根目录下的HoneyComb目录中, 在first_install.sh中相映的配置了要安装的版本。

	#!/bin/bash
	CENTER_SERVER="http://192.168.202.240/HoneyComb/lastest/"

安装完成后, 会创建如下目录, HoneyComb的组件分布在这些目录中。

	/export/
	|-- App          -- 二进制程序
	|-- Data         -- 数据文件
	|-- Logs         -- 日志
	|-- Shell        -- 服务的管理脚本等
	|-- Version      -- 版本信息

>HoneyComb的v0.0.1中没有包含Docker,所以Kubernetes的Node上还需要单独安装Docker。

## 启动

v0.0.1 

>注意: /export/Shell中的脚本使用的都是相对路径,所以运行其中的脚本时,当前目录必须是/export/Shell。

在所有的机器上到/export/Shell目录中运行脚本run.sh, run.sh在运行时会自动发现自己角色, 然后启动相应的HoneyComb服务。

服务的日志被记录在/export/Logs中。

## 管理

v0.0.1 

在任意一台可以访问Kubernetes的ApiServer机器上，使用kubectl进行管理。

	$ ./kubectl -s 192.168.202.244:8080 get nodes     <-- 需要指定ApiServer的地址
	NAME              LABELS    STATUS
	192.168.200.164   <none>    Ready
	192.168.200.165   <none>    NotReady
	192.168.200.166   <none>    Ready
	192.168.200.167   <none>    Ready
	192.168.200.168   <none>    Ready

## 关闭

v0.0.1 

在/export/Shell中运行stop.sh脚本就可以将这台机器上与HoneyComb有关的服务关闭。

将所有的机器关闭后， 整个集群关闭。

## Docker Registry

v0.0.1

Tools/Registry目录中提供了一个Docker Registry。可以按照里面Readme.md文件的说明进行安装。

## kubernetes/pause

kubelet使用到镜像kubernetes/pause，在Shell/kubelete.sh中可以看到：

	Configs[pod-infra-container-image]="--pod-infra-container-image=${DOCKER_REGISTRYS}/kubernetes/pause:latest"

因为功夫墙的原因,kubelet可能不能从默认地址获得pasue镜像。这里下载到一个pause镜像，将其push到了私有的Docker Registry中。

见Tools/Pause。

## 存在的问题

v0.0.1

存在的问题很多, 例如访问控制、容灾等等, 将随着了解的逐步深入和知识经验的积累逐渐完善。

## 文献
