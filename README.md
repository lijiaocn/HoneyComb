---
layout: default
title: README

---

# README

创建时间: 2015/06/26 11:43:54  修改时间: 2015/09/12 11:01:36 作者:lijiao

----

## 摘要

HoneyComb想成为一套简单、高效的Kubernetes的部署系统。

这不是什么高大上东西, 只是在了解Kubernetes的时候, 为了节省以后的时间，而写的一堆堆的脚本。

至于后续, 还不知道:)

向才华横溢的程序员们致敬! Thanks for yours beautiful works!

## 版本

	v0.0.1          用shell脚本实现了基本的自动化部署。
	NextVersion     还没想好。

## 介绍

[Release 0.0.1](./doc/0_release_0.0.1.md)

[Release 0.0.2](./doc/0_release_0.0.2.md)

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

## 杂言

2015-06-26 15:01:24

技术的发展意味着越来越少的人可以做越来越多的工作了, 请为自己的10年以后早做储备, 虽然将会有各种各种新的岗位涌现出来, 那时的你将会如何呢?

--有感某公司最近的一些事情

2015-06-27 15:29:56

回想三国里的吕布，当年“马中赤兔，人中吕布”，何等威猛，英姿飒爽！只可惜先杀丁原、后叛董卓、依王允、奔袁术、投袁绍、靠张邈，仓皇若丧家之犬投靠刘备，只为袁术一纸许诺，破张飞、囚刘备妻室，与袁术联姻又毁，斩术来使，只为附曹操,追杀袁术，再打刘备，使其败而归曹，又倚袁术、还打刘备，又掳其妻室，迫使刘备再归曹，最终众叛亲离，为曹操所获。大耳刘备言：明公不见布之事丁建阳及董太师乎？一言而杀之。

--有感某公司最近的某人品...

## 文献

1.  kubernetes https://github.com/GoogleCloudPlatform/kubernetes/

