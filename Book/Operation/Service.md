---
layout: default
title: Service

---

# Service
创建时间: 2016/04/04 18:14:39  修改时间: 2016/04/04 19:45:24 作者:lijiao

----

## 摘要

使用一个Service

注意：下列对kubernetes的操作是在Deploy/apiserver.local.unsecure/cmd-kubectl/unsecure目录中操作完成的。前面的一些示例是在Deploy/apiserver.local/secure/cmd-kubectl/admin-super或其他用户目录下完成。使用哪种方式创建完全取决于用哪种方式部署的kuberntes。

## 准备WebShell镜像

	$ git clone https://github.com/lijiaocn/Containers.git
	$ cd Containers/WebShell
	$ ./build.sh
	$ sudo docker tag webshell:1.0  registry.local:5000/webshell:1.0
	$ sudo docker push registry.local:5000/webshell:1.0

检查registry.local中是否已经存在sshproxy

	$ cd Tools
	$./registry.sh repo
	{"repositories":["kubernetes/pause","runonce","sshproxy","webshell"]}
	$./registry.sh tags sshproxy
	{"name":"webshell","tags":["1.0"]}

## 创建Service

	$ cd Deploy/apiserver.local.unsecure/cmd-kubectl/unsecure
	$ ./kubectl.sh create -f ../../../../Operation/api-v1-example/webshell-service.json

	$ ./kubectl.sh get service --namespace=first-namespace -o wide
	NAME               CLUSTER-IP    EXTERNAL-IP   PORT(S)   AGE       SELECTOR
	webshell-service   172.16.22.2   <none>        80/TCP    27s       name=webshell,type=pod

## 创建RC

	$ ./kubectl.sh create -f ../../../../Operation/api-v1-example/webshell-rc.json


## 文献
