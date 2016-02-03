---
layout: default
title: Compile

---

# Compile
创建时间: 2016/02/01 11:12:56  修改时间: 2016/02/03 18:26:03 作者:lijiao

----

## 摘要

## 环境要求

	操作系统: Linux
	
	编译工具: Go
	
	依赖软件: godep, git

## 下载源码

	go get github.com/lijiaocn/HoneyComb

>源码将被下载到$GOPATH/src/github.com/lijiaocn/HoneyComb

## 编译

compile.all.sh将完成Compile目录下所有组件的编译, 将编译后得到程序统一存放在./out目录中。

	cd $GOPATH/src/github.com/lijiaocn/HoneyComb/Compile
	./compile.all.sh

>编译过程中会自动获取相应的源码。

编译完成后得到下面的文件，每个子目录下会产生一个out子目录，里面存放着最近编译得到程序。

	▾ Compile/
	  ▾ etcd/
	    ▸ out/
	      etcd.sh*
	  ▾ flannel/
	    ▸ out/
	      flannel.sh*
	  ▾ kubernetes/
	    ▸ out/
	      kubernetes.sh*
	  ▾ registry/
	    ▸ out/
	      registry.sh*
	  ▾ skydns/
	    ▸ out/
	      skydns.sh*
	    compile.all.sh*

也可以对组件进行单独编译, 只需要进入到对应的目录, 执行以组件名命名的脚本。例如要编译etcd:

	cd etcd
	./etcd.sh

得到etcd/out目录:

	▾ etcd/
	  ▸ out/
	    etcd.sh*

## Q&A

### 如何设置组件使用的源码版本？

以etcd为例, 编辑etcd/etcd.sh文件, 将TAG修改为要是用的版本。

	#!/bin/bash
	
	REPO="github.com/coreos/etcd"
	TAG="v2.2.4"
	PWD=`pwd`
	OUT=${PWD}/out/

### 编译后得到out中的目录结构是怎样的？

	▾ etcd/
	  ▾ out/            <-- 编译得到的out
	    ▾ etcd/         <-- 子程序独占目录
	      ▸ bin/        <-- 子程序的二进制实体位于这里
	        etcd.sh*    <-- 启动子程序的脚本, ./etcd.sh [start|stop|restart]
	    ▾ etcdctl/
	      ▾ bin/
	          etcdctl*

## 文献
