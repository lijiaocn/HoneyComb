---
layout: default
title: Pod

---

# Pod
创建时间: 2016/02/24 16:25:09  修改时间: 2016/02/24 17:30:13 作者:lijiao

----

## 摘要

创建第一个pod。

## 准备镜像

这里准备一个镜像，启动后，开启sshd服务，然后进行sleep状态。

	$ git clone https://github.com/lijiaocn/SSHProxy.git
	$ cd SSHPROXY
	$ ./build.sh
	$ sudo docker tag sshproxy:1.0  registry.local:5000/sshproxy:1.0
	$ sudo docker push registry.local:5000/sshproxy:1.0
	
检查registry.local中是否已经存在sshproxy

	$ cd Tools
	$./registry.sh repo
	{"repositories":["kubernetes/pause","sshproxy"]}
	
	$./registry.sh tags sshproxy
	{"name":"sshproxy","tags":["1.0"]}

## 创建pod

	

## 文献
