---
layout: default
title: Registry

---

# Registry
创建时间: 2016/02/14 17:24:37  修改时间: 2016/03/03 18:04:37 作者:lijiao

----

## 摘要

kubelet将从自建的Registry中获取pause镜像，示例中为registry分配的地址是registry.local:5000。

>注意，这里自建的registry.local非常简陋，只用作演示。

计算节点依赖的pause镜像，将存放在registry.local中，正如kubelet中配置的那样：

	--pod-infra-container-image="registry.local:5000/kubernetes/pause:latest

## 编译

	cd Compile/registry
	./registry.sh

## 加密

	cd  AuthnAuthz/registry/
	./gen.sh

## 准备

	cd Deploy/apiserver.local.secure/8-registry/
	./prepare.sh

## 部署

将Deploy/apiserver.local/secure/8-registry/复制到目标位置后，运行其中的registry.sh。

	./registry.sh start

## 提交pause镜像

>计算节点上的kubelet需要pause镜像。

找一台安装有docker的机器，并配置hosts：

	registry.local 192.168.40.99

然后将registry.local的签署ca复制到/etc/docker/certs.d/registry.local:5000中:

	mkdir  /etc/docker/certs.d/registry.local:5000
	cp  AuthnAuthz/registry/ca/ca.pem   /etc/docker/certs.d/registry.local:5000/ca.crt

最后运行:

	cd Tools/Pause
	./load.sh
	./push.sh

可以使用Tools/registry.sh检查镜像是否已经上传到registry.local了。

	cd Tools/
	$./registry.sh repo
	{"repositories":["kubernetes/pause"]}
	$./registry.sh tags kubernetes/pause
	{"name":"kubernetes/pause","tags":["latest"]}

## 文献
