---
layout: default
title: Kubectl

---

# Kubectl
创建时间: 2016/02/01 13:43:34  修改时间: 2016/02/01 13:58:18 作者:lijiao

----

## 摘要

kubectl是kubenetes的命令行工具。

## 使用

kubectl组件目录的结构如下:

	kubectl/
	├── config.yml
	├── kubectl
	├── kubectl.sh
	└── unsecure
	    └── kubeconfig.yml

如果想用unsecure的身份运行kubectl, 只需:

	cd unsecure
	../kubectl.sh get nodes

同理, 如果想用其它的身份运行, 只需要在kubectl/中建立一个以用户名命名的目录, 然后进入运行../kubectl.sh即可。

如果用户目录下米有kubeconfig.yml文件, kubectl.sh会自动以config.yml为模版生成一个。

>如果使用加密, 用户目录中需要提前准备好证书密钥等。

## 文献
