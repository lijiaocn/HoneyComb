---
layout: default
title: README

---

# README

创建时间: 2015/06/26 11:43:54  修改时间: 2016/01/22 19:09:47 作者:lijiao

----

## 摘要

>2016-01-22 18:38:38 擦，我现在也不知道想把这个弄成个啥，丫的，现在就是简化工作的一堆脚本而已～～～～

HoneyComb想成为一套简单、高效的Kubernetes的部署系统。

这不是什么高大上东西, 只是在了解Kubernetes的时候, 为了节省以后的时间，而写的一堆堆的脚本。

至于后续, 还不知道:)

向才华横溢的程序员们致敬! Thanks for yours beautiful works!

## 版本

	v0.0.4          干掉了脚本自动配置打包的部分，重新规整目录。
	v0.0.3          支持选择集群，完成配置编译打包。
	v0.0.1          用shell脚本实现了基本的自动化部署。
	NextVersion     还没想好。

## 更新

>2016-01-22 18:24:06  v0.0.4 中间忙活了一顿别的事情，回来一看，发现当初用release.sh完成编译打包，实在是一件没有意义的事情。部署时，每个机器还是都单独配置一下最好，提前把所有都配置规划好没太大意义。所以在v0.0.4中把哪些乱七八糟都统统干掉了。证书的制作保留了，这个还是挺有意义的:-)

master branch正在0.0.3的版本的整理过程中, 0.0.3对组件的组织方式、启动脚本、打包方式均做出了很大的变动。

>2015-09-27 00:18:46 现在的代码库中没有做好master分支和开发分支的规划, 在0.0.3结束,0.0.4开始的时候进行规划。

[Release 0.0.4](./doc/0_release_0.0.4.md)

[Release 0.0.3](./doc/0_release_0.0.3.md)

[Release 0.0.2](./doc/0_release_0.0.2.md)

[Release 0.0.1](./doc/0_release_0.0.1.md)

## 介绍

[第一篇 在Kubernetes中使用Redis](./doc/1_example_redis.md)

[第二篇 Namespace的使用](./doc/2_example_namespace.md)

[第三篇 Kubernetes的网络](./doc/3_example_networks.md)

[第四篇 Kubernetes All-in-One 和Ui](./doc/4_example_allinone_and_ui.md)

[第五篇 认证与授权](./doc/5_example_authn_authz.md)

[第六篇 加密](./doc/6_example_encryption.md)

## 目录说明

	├── AuthnAuthz             #证书制作与授权策略等
	│   ├── apiserver
	│   ├── authn
	│   ├── authz
	│   ├── kubelets
	│   └── serviceAccount
	├── Compile                #编译
	│   ├── etcd
	│   ├── flannel
	│   ├── kubernetes
	│   ├── registry
	│   └── skydns
	├── doc                    #文档
	├── examples               #示例
	│   ├── 1-redis
	│   └── 2-namespace
	├── PLAN.md
	├── README.md
	└── Tools                  #一些脚本

## 文献

1.  kubernetes https://github.com/GoogleCloudPlatform/kubernetes/
