---
layout: default
title: Install

---

# Install
创建时间: 2016/02/14 11:51:36  修改时间: 2016/03/03 18:37:53 作者:lijiao

----

## 摘要

完成组件需要的文件的汇集之后，就可以把组件复制到任意地方，这里的安装也就是复制一下。

>复制到目标地址之后，根据实际情况，修改组件的配置文件。

## 安装

将Deploy/apiserver.local.secure/中带有编号的目录复制到希望安装到目录，或者不做复制，直接使用当前位置。

	$ls -l Deploy/apiserver.local.secure/
	total 4
	drwxr-xr-x 1 vagrant vagrant 272 Feb 22 09:07 1-etcd
	drwxr-xr-x 1 vagrant vagrant 340 Feb 14 02:57 2-flannel
	drwxr-xr-x 1 vagrant vagrant 374 Feb 14 08:52 3-kube-apiserver
	drwxr-xr-x 1 vagrant vagrant 340 Feb 14 08:52 4-kube-controller-manager
	drwxr-xr-x 1 vagrant vagrant 340 Feb 14 06:46 5-kube-scheduler
	drwxr-xr-x 1 vagrant vagrant 340 Feb 14 06:46 6-kube-proxy
	drwxr-xr-x 1 vagrant vagrant 340 Feb 22 09:31 7-kubelet
	drwxr-xr-x 1 vagrant vagrant 476 Feb 22 09:14 8-registry
	drwxr-xr-x 1 vagrant vagrant 170 Feb 14 06:35 cmd-etcdctl
	drwxr-xr-x 1 vagrant vagrant 204 Feb 14 07:58 cmd-kubectl
	-rwxr-xr-x 1 vagrant vagrant 113 Feb  3 07:17 prepare.all.sh

>注意必须是prepare.sh成功运行再安装，否则可能文件不全或者目录缺失。

## 文献
