---
layout: default
title: ApiServerNode

---

# ApiServerNode
创建时间: 2016/03/03 18:19:19  修改时间: 2016/03/03 18:32:11 作者:lijiao

----

## 摘要

ApiServerNode的准备。

>这里ApiServerNode和ComputeNode是同一台机器上，都是192.168.40.99。etcd服务也部署在这台机器上。

>当然这不是说只能这样子，分开部署也可以，只需要修改host中的IP，并修改每个组件中的配置文件中与IP相关的配置即可。

## 配置Host

	192.168.40.99 apiserver.local
	192.168.40.99 etcd.local
	192.168.40.99 kubelet.local

## 文献
