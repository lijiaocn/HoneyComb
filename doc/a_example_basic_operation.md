---
layout: default
title: 8_example_basic_operation

---

# 8_example_basic_operation
创建时间: 2015/09/28 13:51:57  修改时间: 2015/09/28 16:07:18 作者:lijiao

----

## 摘要

模拟一个新用户从零开始的过程。

## 申请帐号

需要向k8s的管理员申请一个用户帐号(user-alice)。

k8s的管理员该用户签署一个cn为"user-alice"的证书: [签署用户证书](./AuthnAuthz/allinone-secure/authn/)

k8s的管理员为该用户创建一个同名的namespace(pkg/api/v1/types.go: Namespace):

	kubectl create -f namespace-user-alice.yaml

namespace-user-alice.yaml:

		kind: Namespace
		apiVersion: v1
		metadata:
		  name: kube-system

k8s管理员为该用户设置操作权限, 在apiserver的policy.json文件中添加:

	{"user":"user-alice", "namespace": "user_alice"}

重启apiserver。

k8s管理员将给签署的用户证书发送给用户。

>k8s的v1.0.0中的授权机制需要重启apiserver。需要将用户管理和授权实现为一个服务。

## 


## 文献


