---
layout: default
title: ComputeNode

---

# ComputeNode
创建时间: 2016/02/14 17:07:10  修改时间: 2016/02/22 17:30:30 作者:lijiao

----

## 摘要

ComputeNode是运行任务容器的节点，上面将运行有docker、kubelete、kube-proxy、flanneld。

## Apiserver可达

确保计算节点能够访问控制节点。

这里的示例在hosts中配置apiserver.local的地址:

	192.168.40.99 apiserver.local

## docker

容器可以是docker或者rkt，这里使用的是docker。

## registry.local

需要将自建的registry的签署ca复制到指定位置：

	mkdir  /etc/docker/certs.d/registry.local:5000
	cp ../AuthnAuthz/registry/ca/ca.pem   /etc/docker/certs.d/registry.local:5000/ca.crt

在/etc/hosts中配置registry.local：

	registry.local  192.168.40.99

计算节点依赖的pause镜像，需要在kubelete的config文件中指定，如下：

	--pod-infra-container-image="registry.local:5000/kubernetes/pause:latest

## 文献
