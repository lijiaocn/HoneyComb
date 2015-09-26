---
layout: default
title: README

---

# README

创建时间: 2015/06/26 11:43:54  修改时间: 2015/09/25 15:36:48 作者:lijiao

----

## 摘要

HoneyComb想成为一套简单、高效的Kubernetes的部署系统。

这不是什么高大上东西, 只是在了解Kubernetes的时候, 为了节省以后的时间，而写的一堆堆的脚本。

至于后续, 还不知道:)

向才华横溢的程序员们致敬! Thanks for yours beautiful works!

## 版本

	v0.0.1          用shell脚本实现了基本的自动化部署。
	NextVersion     还没想好。

## 更新

## 介绍

[Release 0.0.1](./doc/0_release_0.0.1.md)

[Release 0.0.2](./doc/0_release_0.0.2.md)

[Release 0.0.3](./doc/0_release_0.0.3.md)

[第一篇 在Kubernetes中使用Redis](./doc/1_example_redis.md)

[第二篇 Namespace的使用](./doc/2_example_namespace.md)

[第三篇 Kubernetes的网络](./doc/3_example_networks.md)

[第四篇 Kubernetes All-in-One 和Ui](./doc/4_example_allinone_and_ui.md)

[第五篇 认证与授权](./doc/5_example_authn_authz.md)

## 目录说明

v0.0.1

运行gen.sh后,整个目录结构将如下:

	HoneyComb/
	|-- batch.sh                  -- 批量执行远程操作的工具
	|-- doc                       -- 文档
	|   |-- 0_deploy.md
	|   `-- pic
	|-- examples                  -- Kubernetes的一些使用示例
	|   `-- 1
	|-- first_install.sh          -- 首次安装HoneyComb使用的脚本
	|-- gen.sh                    -- HoneyComb的编译、打包脚本
	|-- kubectl.sh                -- 便捷使用kubctl程序
	|-- machines.lst              -- 集群机器的列表
	|-- OutPut                    -- HoneyComb编译、打包后的输出
	|   |-- base_version          -- [中间文件] base.sh文件的Sha1Num
	|   |-- export                -- [中间文件] HoneyComb的主体
	|   |-- export.tar.gz         -- [中间文件] HoneyComb的主体的压缩包
	|   |-- export_version        -- [中间文件] HoneyComb的主体压缩包的Sha1Num
	|   `-- FinalPackage          -- HoneyComb的发布包
	|-- README.md                 -- Readme
	|-- Shell                     -- HoneyComb的代码
	|   |-- apiserver.sh
	|   |-- base.sh
	|   |-- docker.sh
	|   |-- etcd.sh
	|   |-- flanneld.sh
	|   |-- flannel.json
	|   |-- kubelet.sh
	|   |-- kube-proxy.sh
	|   |-- library.sh
	|   |-- manager.sh
	|   |-- run.sh
	|   |-- scheduler.sh
	|   |-- stop.sh
	|   `-- update.sh
	|-- ThirdParty                -- HoneyComb中使用的第三方项目
	|   |-- Etcd
	|   |-- Flannel
	|   `-- Kubernetes
	|-- TODO                      -- 待办事项
	|-- Tools                     -- 一些辅助内容, 例如Docker Registry
	`-- version                   -- 当前版本


## 文献

1.  kubernetes https://github.com/GoogleCloudPlatform/kubernetes/

