---
layout: default
title: Log

---

# Log
创建时间: 2016/02/14 12:03:54  修改时间: 2016/03/03 18:43:29 作者:lijiao

----

## 摘要

如果日志太少，可以在组件的配置文件提高日志级别，“--v=XXX”。

## 输出

每个组件的标准输出和错误输出默认保存在运行目录下的log子目录中。

在启动脚本中设置，例如kube-apiserver.sh:

	...（省略）...
	func_service_template_1 ./bin/kube-apiserver ./log  CONFIGS  $1

日志文件如下：

	▾ log/
		kube-apiserver.operate      //启动运行记录
		kube-apiserver.pid          //进程pid
		kube-apiserver.stderr       //错误输出
		kube-apiserver.stdout       //标准输出

## 文献
