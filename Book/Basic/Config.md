---
layout: default
title: Config

---

# Config
创建时间: 2016/02/14 10:57:56  修改时间: 2016/03/03 18:32:07 作者:lijiao

----

## 摘要

## 配置

Deploy/apiserver.local.secure中每个带编号的子目录中对应一个组件，每个组件都有一个名为config的文件。

每个带编号的子目录都是一个组件，以组件名命名的脚本启动时会读取config文件中的配置。

	./Deploy/apiserver.local.secure/1-etcd/config
	./Deploy/apiserver.local.secure/2-flannel/config
	./Deploy/apiserver.local.secure/3-kube-apiserver/config
	./Deploy/apiserver.local.secure/4-kube-controller-manager/config
	./Deploy/apiserver.local.secure/5-kube-scheduler/config
	./Deploy/apiserver.local.secure/6-kube-proxy/config
	./Deploy/apiserver.local.secure/7-kubelet/config
	./Deploy/apiserver.local.secure/8-registry/config

>注意: kubernetes的一些运行参数还不能识别域名，只能配置IP地址。配置文件中的192.168.40.99，是kubernetes的apiserver所在的机器的IP。

## 文献
