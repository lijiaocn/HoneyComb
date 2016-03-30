---
layout: default
title: RunOnce

---

# RunOnce
创建时间: 2016/03/29 14:57:34  修改时间: 2016/03/29 20:38:39 作者:lijiao

----

## 摘要

这里主要试验一下，kubernetes会如何处理自动退出的容器。

## 准备镜像

	$ git clone https://github.com/lijiaocn/RunOnce.git
	$ cd RunOnce
	$ ./build.sh
	$ sudo docker tag runonce:1.0  registry.local:5000/runonce:1.0
	$ sudo docker push registry.local:5000/runonce:1.0

## 创建pod

	$ cd cmd-kubectl/secure/admin-super
	$ ../kubectl.sh create -f ../../../../Operation/api-v1-example/pod-runonce.json

运行结束后，可以看到pod被标记为Completed状态:

	$ ./kubectl.sh get pods  -a --namespace=first-namespace
	NAME       READY     STATUS      RESTARTS   AGE
	runonce    0/1       Completed   0          50s

如果结束的Pod的数量超过了kube-controller-manager中的设置，将会触发gc。

	--terminated-pod-gc-threshold=12500

## 文献
