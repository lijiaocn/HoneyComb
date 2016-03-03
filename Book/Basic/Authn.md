---
layout: default
title: Authn

---

# Authn
创建时间: 2016/02/14 10:50:04  修改时间: 2016/03/03 18:27:22 作者:lijiao

----

## 摘要

## 通过证书认证

### 制作

只需要在AuthnAuthz/authn中执行gen.sh脚本即可。

	$cd AuthnAuthz
	$./gen.sh

### 说明

	1. 用于签署用户的用户身份凭证的公钥的CA，位于AuthnAuthz/authn/ca；
	2. 用户用作身份凭证的密钥对，位于AuthnAuthz/users/{用户名}；
		admin-cluster
		admin-project
		heapster
		kube-controller-manager
		kube-kubelet
		kube-proxy
		kube-scheduler
		kube2sky
		user-alice
		user-bob
		user-guest

## 通过密码认证

(暂空)

## 文献
