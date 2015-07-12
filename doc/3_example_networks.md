---
layout: default
title: 3_example_networks

---

# 3_example_networks
创建时间: 2015/07/12 09:52:53  修改时间: 2015/07/12 11:11:58 作者:lijiao

----

## 摘要

2015-07-12 10:33:16   该文章中的内容，还未进行实际验证。

这一节分析网络相关的部分。

在前面的两篇文章的中，说明了Kubernetes的中Service的用途。那么访问Service时，整个的流程是怎样的？这个问题好比“当你在浏览器里打开一个网页时，都发生了什么？”。了解访问Serice的流程，有助于我们做出正确的选择。

这里以v1版本的api为例，v1beta3->v1之间发生不少变化。

## Service的类型

这里先只列出v1.0中，Service的三种类型:

	// ServiceTypeClusterIP means a service will only be accessible inside the
	// cluster, via the cluster IP.
	ServiceTypeClusterIP ServiceType = "ClusterIP"

	// ServiceTypeNodePort means a service will be exposed on one port of
	// every node, in addition to 'ClusterIP' type.
	ServiceTypeNodePort ServiceType = "NodePort"

	// ServiceTypeLoadBalancer means a service will be exposed via an
	// external load balancer (if the cloud provider supports it), in addition
	// to 'NodePort' type.
	ServiceTypeLoadBalancer ServiceType = "LoadBalancer"

各个类型的含义，上面的注释中已经说明了。我们真正关心的不是有多杀类型，而是要怎样实现我们要求。所以这里我们不对这些类型做比较分析，而是直接在后续的章节中讨论“我们需要的各种场景要如何实现”。

## 场景1 - Service如何暴露到Internet

这是最重要的场景，如果Service无法对外服务，那么这就只能是个内部自娱自乐的东西。

这种场景可以用NodePort和LoadBalancer实现，而LoadBalancer是基于的NodePort的。

### NodePort方式

先要明确的一点是，Kubernetes的设计思想中，每个Node都是拥有公网IP，与公网联通的！

仔细观察：

![k8s-architecture](./pic/pic_3_1_K8s_architecture)

>注意:只有Node是必须与公网联通，而承担etcd、manager、scheduler的结点不需要。

因为每个Node都是可以从公网访问的，因此直接将Service通过这些Node的公网IP暴露出去即可。公网的用户访问的Service的时候，只需要访问任意一个Node的公网地址。

那么问题也随之而来了，多个Service之间如何区分？Kubernetes中对个问题的回答也是很简单粗暴的——端口！

通过在manager中的配置，所有的Node都预留了一部分端口(default: 30000-32767)用于Service的区分。例如:

	  Service       Port
	 -----------------------
	 ServiceA      30000
	 ServiceB      30001

	  Node         PublicIP
	 -----------------------
	  Node1         IP1
	  Node2         IP2
	  Node3         IP3

当公网用户要使用ServiceA时，使用地址[IP1|IP2|IP3]:30000。

当公网用户要使用ServiceB时，使用地址[IP1|IP2|IP3]:30001。

>这里最直接的一个问题就是：可以公布的Service的数量受限于端口数！I think this is a problem，this soluation is not graceful.

### Loadbalancer方式



## 文献
