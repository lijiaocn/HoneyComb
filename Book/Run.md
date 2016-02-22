---
layout: default
title: Run

---

# Run
创建时间: 2016/02/03 17:55:38  修改时间: 2016/02/22 17:53:13 作者:lijiao

----

## 摘要

## 启动

依次启动安装好的组件。下面的示例中直接在Deploy/apiserver.local.secure中启动组件。

在Deploy/apiserver.local.secure的子目录依次执行以组件命名的脚本。

按照如下顺序启动组件:

	etcd --> flannel --> kube-apiserver --> kube-controller-manager 
	                                        kube-scheduler
	                                        kubelete
	                                        kube-proxy

以etcd为例:

	$cd  Deploy/apiserver.local.secure/1_etcd
	$./etcd.sh start     

>flannel在启动之前，需要先执行./net_init_config.sh, 在etcd中写入配置。

>一些组件需要有root权限, 例如kubelet。

默认在当前目录下生成一个log目录，里面记录有程序的标准输出和错误输出，以及操作历史。

	▾ log/
		kube-apiserver.operate      //启动运行记录
		kube-apiserver.pid          //进程pid
		kube-apiserver.stderr       //错误输出
		kube-apiserver.stdout       //标准输出

## 文献
