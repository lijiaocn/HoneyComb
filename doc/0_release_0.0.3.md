---
layout: default
title: 0_release_0.0.3

---

# 0_release_0.0.3
创建时间: 2015/09/25 15:37:04  修改时间: 2015/09/25 15:41:52 作者:lijiao

----

## 摘要

## 配置

编辑Config/allinone-secure/Shell/config-global/base.sh

## 设置组件版本

编辑Config/allinone-secure/config

## 准备证书

	cd AuthnAuthz/allinone-secure
	cd apiserver; ./gen.sh; cd ..
	cd authn; ./gen.sh; cd ..
	cd kubelets; ./gen.sh; cd ..

	./setup.sh

## 编译打包

	./release.sh

## 文献


