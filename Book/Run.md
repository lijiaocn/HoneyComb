---
layout: default
title: Run

---

# Run
创建时间: 2016/02/03 17:55:38  修改时间: 2016/02/03 17:56:38 作者:lijiao

----

## 摘要

## 启动

在Deploy/apiserver.local.secure的子目录依次执行以组件命名的脚本。

按照如下顺序启动组件:

	etcd --> flannel --> kube-apiserver --> kube-controller-manager 
	                                        kube-scheduler
	                                        kubelete
	                                        kube-proxy

启动方式以etcd为例:

	$cd  Deploy/apiserver.local.secure/1_etcd
	$./etcd.sh start     

>flannel在启动之前，需要先执行./net_init_config.sh, 在etcd中写入配置。

>一些组件需要有较高的运行的权限, 例如kubelet。

## 文献

1. http://xxx  "Name"
