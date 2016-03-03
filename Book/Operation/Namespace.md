---
layout: default
title: Namespace

---

# Namespace
创建时间: 2016/02/01 11:09:14  修改时间: 2016/02/25 11:48:34 作者:lijiao

----

## 摘要

Namespace操作。

## 创建

	$ cd cmd-kubectl/secure/admin-super
	$ ../kubectl.sh create -f ../../../../../Operation/api-v1-example/namespace.json
	namespace "first-namespace" created
	
	$ ../kubectl.sh get namespace
	NAME              LABELS                                      STATUS    AGE
	default           <none>                                      Active    20d
	first-namespace   name=FirstNameSpace,purpose=Demonstration   Active    23s

## 查看

	$ ../kubectl.sh get namespace first-namespace -o yaml
	apiVersion: v1
	kind: Namespace
	metadata:
	  annotations:
	    describe: Just show how to create
	  creationTimestamp: 2016-02-24T05:36:15Z
	  generateName: first-namespace
	  labels:
	    name: FirstNameSpace
	    purpose: Demonstration
	  name: first-namespace
	  resourceVersion: "2554"
	  selfLink: /api/v1/namespaces/first-namespace
	  uid: 8563f7bc-dab8-11e5-87b0-080027d4b3b6
	spec:
	  finalizers:
	  - kubernetes
	status:
	  phase: Active

## 为Namespace设置资源配额(Quota)

[可以设置配额的资源](https://github.com/kubernetes/kubernetes/blob/release-1.1/docs/design/resources.md#resource-specifications)

>CPU的单位是“KCU”，Kubernetes将计算能力统一转化用“KCU”计量的数值。1个KCPU的计算能力约等于x86处理器的一个超线程。

配额是一个Namespace能够使用的最大的资源数量。

配额数量可以使用下面的后缀单位:

	"Ki", bePair{2, 10}
	"Mi", bePair{2, 20}
	"Gi", bePair{2, 30}
	"Ti", bePair{2, 40}
	"Pi", bePair{2, 50}
	"Ei", bePair{2, 60}
	"m" , bePair{10, -3}
	"k" , bePair{10, 3}
	"M" , bePair{10, 6}
	"G" , bePair{10, 9}
	"T" , bePair{10, 12}
	"P" , bePair{10, 15}
	"E" , bePair{10, 18}

为fist-namespace创建配额：

	$ ../kubectl.sh create -f ../../../../../Operation/api-v1-example/resourcequotas.json
	resourcequota "first-quota" created
	
	$ ../kubectl.sh get quota --namespace=first-namespace
	NAME          AGE
	first-quota   15s
	
	$ ../kubectl.sh describe quota first-quota  --namespace=first-namespace
	Name:                   first-quota
	Namespace:              first-namespace
	Resource                Used   Hard
	--------                ----   ----
	cpu                       0    10
	memory                    0    128Mi
	persistentvolumeclaims    0    3
	pods                      0    5
	replicationcontrollers    0    3
	resourcequotas            1    1
	secrets                   2    3
	services                  0    3

## 问题

### spec.finalizers的用途是?

## 文献
