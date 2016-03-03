---
layout: default
title: README

---

# README
创建时间: 2016/02/03 17:25:51  修改时间: 2016/03/03 16:21:07 作者:lijiao

----

## 摘要

Kubernetes实战记录。

以下章节中部署的是一个“All in One”、“启用了https加密”和“用户授权”的kubernetes系统。

## 准备

[自建Registry](./Registry.md)

[计算节点](./ComputeNode.md)

## 编译

[编译](./Compile.md)：完成相关kubernetes以及依赖的etcd的等程序（暂时不包含docker）的编译。

## 规划

[加密](./Secure.md)：kubernetes组件之间的通信加密（暂时不包含kubernetes以外的组件）。

[认证](./Authn.md)：kubernetes用户的认证。

[授权](./Authz.md)：kubernetes对用户授权。

## 部署

[配置](./Config.md)：各个组件的配置。

[准备](./Prepare.md)：安装文件汇总。

[安装](./Install.md)：将组件安装到希望的位置。

[运行](./Run.md)：启动。

## 命令行

[命令行](./Cli.md)

## 排错

[日志](./Log.md)：日志。

[事件](./Events.md)：事件。

## 操作

[操作前准备](./Operation/Prepare.md)：操作前准备。

[Namespace](./Operation/Namespace.md)：Namespace操作。

[Pod](./Operation/Pod.md)

## 进阶

[对接keystone](./Advanced/keystone.md)

## 问题

[问题](./Questions.md)：问题。

## 文献
