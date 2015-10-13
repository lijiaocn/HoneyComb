---
layout: default
title: a_example_basic_operation

---

# a_example_basic_operation
创建时间: 2015/09/28 13:51:57  修改时间: 2015/10/10 17:25:40 作者:lijiao

----

## 摘要

模拟一个新用户从零开始的过程。

## 申请帐号

需要向k8s的管理员申请一个用户帐号(user-alice)。

k8s的管理员该用户签署一个cn为"user-alice"的证书: [签署用户证书](./AuthnAuthz/allinone-secure/authn/)

k8s管理员将给签署的用户证书发送给用户。

## 申请namespace

用户申请namespace, 申请中提供:

	namespace名称
	ResoureceQuota(namesapce的资源上限): 
		pods
		services
		replicationcontrollers
		resourcequotas
		secrets
		persistentvolumneclaims
	Limits(资源单位限制): pod、容器的资源占用范围(不能太小，也不能太大)

[Resource Quota](https://github.com/kubernetes/kubernetes/blob/v1.0.6/docs/admin/resource-quota.md)

[Limits](https://github.com/kubernetes/kubernetes/tree/v1.0.6/docs/user-guide/limitrange)

管理员根据用户要求创建namespace, 设置ResouceQuota和Limits。

Namespace example:

	kind: Namespace
	apiVersion: v1
	metadata:
	  name: user-alice

ResouceQuota example:

	apiVersion: v1
	kind: ResourceQuota
	metadata:
	  name: user-alice-quota
	spec:
	  hard:
	    cpu: "20"
	    memory: 1Gi
	    persistentvolumeclaims: "10"
	    pods: "10"
	    replicationcontrollers: "20"
	    resourcequotas: "1"
	    secrets: "10"
	    services: "5"

Limit example:

	apiVersion: v1
	kind: LimitRange
	metadata:
	  name: user-alice-limits
	spec:
	  limits:
	  - max:
	      cpu: "2"
	      memory: 1Gi
	      storage: 20Gi
	    min:
	      cpu: 50m
	      memory: 6Mi
	      storage: 5Gi
	    type: Pod
	  - default:
	      cpu: 250m
	      memory: 100Mi
	      storage: 5Gi
	    max:
	      cpu: "2"
	      memory: 1Gi
	      storage: 20Gi
	    min:
	      cpu: 50m
	      memory: 6Mi
	      storage: 5Gi
	    type: Container

然后给用户授予操作该namespace的权限, 在apiserver的policy.json文件中添加(需要重启apiserver):

	{"user":"user-alice", "namespace": "user_alice"}


## 创建pod、rc和services



## 文献


