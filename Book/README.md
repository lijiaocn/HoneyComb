---
layout: default
title: README

---

# README
创建时间: 2016/02/03 17:25:51  修改时间: 2016/04/04 19:49:19 作者:lijiao

----
## 注意

在向kuberntes提交json文件时，可能会经常遇到json文件格式不对或者错误的情况，kuberntes会告知在时在json文件的第几个字节处出错的

	unable to decode "../../../../Operation/api-v1-example/webshell-rc.json": [pos 2710]: json: expect char '{' but got char '"'

上面的提示第2710个字节的取值错误，如果使用vim编辑器，使用命令":2710go"就可以跳转到第2710个字节处。

## 摘要

Kubernetes实战记录。

以下章节中部署了一个“All in One”、“启用了https加密”和“用户授权”的kubernetes系统。

>分开部署也可以，只需要修改ApiServerNode和ComputeNode的host文件中的IP，并修改每个组件的配置文件中与IP相关的配置即可。

组件的安装规划与配置位于[Deploy/apiserver.local.secure](../Deploy/apiserver.local.secure)目录中。

>下面章节中贴出的操作过程中，不是从"/"开始的路径，都是相对于[HoneyComb](https://github.com/lijiaocn/HoneyComb/tree/v0.0.4)的路径。

## 准备

[自建Registry](./Basic/Registry.md)：不是必须的，可以使用其它的registry服务。

[计算节点](./Basic/ComputeNode.md)：在计算节点上配置好host、准备docker等。

[管理节点](./Basic/ApiServerNode.md)：在ApiServerNode上配置好host等。

## 基础

### 编译

[编译](./Basic/Compile.md)：完成相关kubernetes以及依赖的etcd的等程序（不包含docker）的编译。

### 规划

[加密](./Basic/Secure.md)：kubernetes组件之间的通信加密（暂时不包含kubernetes以外的组件）。

[认证](./Basic/Authn.md)：kubernetes用户的认证。

[授权](./Basic/Authz.md)：kubernetes对用户授权。

### 部署

[配置](./Basic/Config.md)：各个组件的配置。

[汇集](./Basic/Prepare.md)：组件需要的文件汇集。

[安装](./Basic/Install.md)：将组件安装到希望的位置。

[运行](./Basic/Run.md)：启动。

### 命令行

[命令行](./Basic/Cli.md)

### 排错

[日志](./Basic/Log.md)：日志。

[事件](./Basic/Events.md)：事件。

### 操作

[操作前准备](./Operation/Prepare.md)：操作前准备。

[Namespace](./Operation/Namespace.md)：Namespace操作。

[Pod](./Operation/Pod.md)：Pod操作。

[Service](./Operation/Service): Service操作。

## 进阶

[对接keystone](./Advanced/keystone.md)：通过keystone认证。

## 问题

[问题](./Questions.md)：问题。



## 文献
