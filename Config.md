---
layout: default
title: Config

---

# Config
创建时间: 2016/02/14 10:57:56  修改时间: 2016/02/14 11:40:00 作者:lijiao

----

## 摘要

## 配置

Deploy/apiserver.local.secure中每个带编号的子目录中都有一个名为config的文件。每个带编号的子目录都是一个组件，启动时会使用对应的config文件中的配置。

>注意: kubernetes的一些运行参数不能识别域名，只能配置IP地址，这里的示例中使用的IP是192.168.40.99，是kubernetes的master所在的机器的IP。

## 文献
