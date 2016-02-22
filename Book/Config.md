---
layout: default
title: Config

---

# Config
创建时间: 2016/02/14 10:57:56  修改时间: 2016/02/22 17:34:33 作者:lijiao

----

## 摘要

## 配置

Deploy/apiserver.local.secure中每个带编号的子目录中都有一个名为config的文件。

每个带编号的子目录都是一个组件，启动时会使用各自的config文件中的配置。

	./Deploy/apiserver.local.secure/1-etcd/config
	./Deploy/apiserver.local.secure/2-flannel/config
	./Deploy/apiserver.local.secure/3-kube-apiserver/config
	./Deploy/apiserver.local.secure/4-kube-controller-manager/config
	./Deploy/apiserver.local.secure/5-kube-scheduler/config
	./Deploy/apiserver.local.secure/6-kube-proxy/config
	./Deploy/apiserver.local.secure/7-kubelet/config
	./Deploy/apiserver.local.secure/8-registry/config

>注意: kubernetes的一些运行参数不能识别域名，只能配置IP地址，这里的示例中使用的IP是192.168.40.99，是kubernetes的master所在的机器的IP。

## 文献
