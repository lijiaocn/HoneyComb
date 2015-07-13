---
layout: default
title: 3_example_networks

---

# 3_example_networks
创建时间: 2015/07/12 09:52:53  修改时间: 2015/07/13 21:54:58 作者:lijiao

----

## ChangeLog

2015-07-12 10:33:16   该文章中的内容，还未进行实际验证。

2015-07-14 17:06:06   增加了“场景1->LoadBalancer方式”、“场景1->问题与改进”、“场景2”、“SDN”

## 摘要

这一节分析网络相关的部分。

在前面的两篇文章的中，说明了Kubernetes的中Service的用途。那么访问Service时，整个的流程是怎样的？这个问题好比“当你在浏览器里打开一个网页时，都发生了什么？”。了解访问Service的流程，有助于我们做出正确的选择。

这里以v1版本的api为例，v1beta3->v1之间发生不少变化。

## Service的类型

这里先只列出v1.0中Service的三种类型:

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

各个类型的含义，上面的注释中已经说明了。我们真正关心的不是有多少种类型，而是要怎样实现我们要求。所以这里我们不对这些类型做比较分析，而是直接在后续的章节中讨论“我们需要的各种场景要如何实现”。

## 场景1 - Service如何发布到公网

这是最重要的场景，如果Service无法对外服务，那么这就只能是个内部自娱自乐的东西。

这种场景可以用NodePort和LoadBalancer实现，而LoadBalancer是基于的NodePort的。

### NodePort方式

先要明确的一点是，Kubernetes的设计思想中，每个Node都是拥有公网IP，与公网联通的！

仔细观察: 

![k8s-architecture](./pic/pic_3_1_K8s_architecture.png)

>注意:只有Node是必须与公网联通，而承担etcd、manager、scheduler的结点不需要。

因为每个Node都是可以从公网访问的，因此直接将Service通过这些Node的公网IP暴露出去即可。公网的用户访问的Service的时候，只需要访问任意一个Node的公网地址。

那么问题也随之而来了，多个Service之间如何区分？Kubernetes中对个问题的回答也是很简单粗暴的——端口！

通过在manager中的配置，所有的Node都预留了一部分端口(default: 30000-32767)用于Service的区分。例如:

	  Service       Port
	 -----------------------
	 ServiceA      30000
	 ServiceB      30001
                                    当公网用户要使用ServiceA时，使用地址[IP1|IP2|IP3]:30000。
	  Node         PublicIP           
	 -----------------------        当公网用户要使用ServiceB时，使用地址[IP1|IP2|IP3]:30001。
	  Node1         IP1
	  Node2         IP2
	  Node3         IP3

>这里最直接的一个问题就是: 可以公布的Service的数量受限于端口数！I think this is a problem，this soluation is not graceful.

### LoadBalancer方式

LoadBalancer方式是在NodePort方式的基础上，接入了外部的LB。Service的类型设定为LoadBalancer之后，会从外部的LB获得一个ingress IP。

	"status": {
		"loadBalancer": {
			"ingress": [
			{
				"ip": "146.148.47.155"
			}
			]
		}

Ingress IP从外部的LB获得，具体的获取方式取决于外部LB的实现。我们可以构想出下面的拓扑: 

	                                  Internet                  1. 只有LB是暴露在公网的
	                                                                 
	                                                                   |
	  -------------------------------------+---------------------      |      -------------
	                                       |                          _|_
	                                       |                          \ /
	                                       |     +---------------------'------------------+
	                                       |     |                 Load Balancer          |
	                                       |     +----------------------------------------+
	                                       |
	                  +---------+          |         +---------+  +---------+  +---------+
	                  |ApiServer|          +----+    |   Node  |  |   Node  |  |   Node  |
	                  |         |               |    |         |  |         |  |         |
	                  +---------+               |    +---------+  +---------+  +---------+
	           +---------+     +---------+           +---------+  +---------+  +---------+
	           | Manager |     |Scheduler|   ----|>  |   Node  |  |   Node  |  |   Node  |
	           |         |     |         |           |         |  |         |  |         |
	           +---------+     +---------+      |    +---------+  +---------+  +---------+
	      +---------+  +---------+  +---------+ |    +---------+  +---------+  +---------+
	      |   Etcd  |  |   Etcd  |  |   Etcd  | |    |   Node  |  |   Node  |  |   Node  |
	      |         |  |         |  |         | |    |         |  |         |  |         |
	      +---------+  +---------+  +---------+ |    +---------+  +---------+  +---------+
	                                            |  
	           3.最高安全级别区域,                    2. 公网用户的请求经由LB转发到Node，
	             控制器与Node之间有严格的网络管          公网用户看不到Node的IP。


                                             
从上面设想的拓扑图中可以看到，引入LB之后，Node无需暴露在公网中，服务的公网IP挂到LB上，由LB负责将请求转发到任意Node上。

因为这些发布到公网中的服务在Node上还是通过NodePort进行区分的，所以LB只需将访问请求转发到任意一台Node的指定端口上。例如:

	Service     IngressIP(PublicIP)  ServicePort     NodePort
	----------------------------------------------------------
	ServiceA        IPA                  80            30000
	ServiceB        IPB                  443           30001


	Node       NodeIP(InternalIP)
	------------------------------------------
	 N1             IP1
	 N2             IP2
	 N3             IP3
	 N4             IP4

	LBRules         Operation
	---------------------------------------------------------------------------
	 1         目的地址是IPA:80的报文， 将目的地址修改为[IP1|IP2|IP3|IP4]:30000
	 2         目的地址是IPB:443的报文，将目的地址修改为[IP1|IP2|IP3|IP4]:30001
	 3         源地址是[IP1|IP2|IP3|IP4]:30000的报文，将源地址修改为IPA:80
	 4         源地址是[IP1|IP2|IP3|IP4]:30001的报文，将源地址修改为IPB:443

>因为LoadBalancer类型基于NodePort类型，所以能够对外发布的服务的数量同样受限于的端口的数量

### 问题与改进

#### 报文转发拉低网络性能

无论是来自公网的请求，还是系统内部对依赖的服务的请求，产生的报文都需要由Node转发到提供服务的实例上。

现在Kubernetes是利用iptables和用户态的转发程序(以后将只使用iptables)实现报文的转发，这样必然会拉低网络性能。

改进1:

	情形: 接收到一个来自公网的请求的Node上面可能没有运行这个服务的实例，这时Node需要将其转发给其它的Node。
	改进: 可以将“服务实例所在的Nodes”告知LB，LB直接将报文转发到运行有对应服务的实例的Node上。
	效果: 通过在LB上增加一点点处理，就可以使从公网的来的请求不再经过Node转发。

#### 端口资源限制了服务的扩增

假设一个对外服务依赖3个内部微服务，再预留一些系统自用的端口，那么最多只能对外发布15000(60000/4)个服务。

改进1:

	思路1:
	如果继续延续按照端口区分的思路，现在NodePort是对于所有的Node都适用的，相当于所有的Node被抽象成了一个大的机器。
	之所以要在所有的Node上设置端口，是为了使每个Node都可以处理来自公网的请求。但是如果我们采用了上一节中的改进,
	来自公网的请求统一由LB处理，那么每个Node上只需要设置自己所承担的服务的"NodePort"。
	因为一个Service只会占用有限的Node，所以只要不停地增加Node的数量，可以对外公布的服务数量就是无限的。
	这时候的服务实质是通过“一组Node的IP+Port”来标记，而不再只是通过“Port”来标记。

## 场景2 - 如何把Kubernetes系统外的服务接入系统内

总会有一些服务是在Kubernetes系统之外的，可能是因为是在逐步的迁移，也可能是出于性能考虑，也可能是购买的第三方服务。

只要做好网络规划，直接访问这些外部的服务是没有问题的，但是需要在程序中记录好这些地址。有没有办法像使用Kubernetes内部的服务一样，使用这些外部服务？

Kubernetes提供了“EndPoints”用来满足这种需求。EndPoints就是创建了一个虚拟的服务，这个服务的地址是人为配置的。

	{
		"kind": "Endpoints",
		"apiVersion": "v1",
		"metadata": {
			"name": "my-service"
		},
		"subsets": [
		{
			"addresses": [
			{ "IP": "1.2.3.4" }
			],
				"ports": [
				{ "port": 80 }
			]
		}
		]
	}

请求普通的服务时，请求被转发到提供服务的实例上，请求“EndPoints”时，请求被转发到配置好的地址上。例如对上面my-service的请求会被转发到1.2.3.4:80。

有了EndPoints之后，我们就可以向下面这样充实我们在上一节中假想的拓扑(增加了4和5):


	                                                                                                  5. +-------------------+
	                                                                                                     |                   |
	                                                                                          +------|>  | Other Companies's |
	                                  Internet                  1. 只有LB是暴露在公网的       |          |      services     |
	                                                                                          |          +-------------------+
	                                                                  |                      NAT          
	 ---------------------------------------+-------------------      |      --------------   |  -+-----------------------------
	                                        |                        _|_                      |   |                           
	                                        |                        \ /                      |   |
	                                        |     +-------------------'------------------+    |   |    +----------------+
	                                        |     |               Load Balancer          |    |   |    |  Storage       |
	                                        |     +--------------------------------------+    |   |    |                |
	                                        |                                                 |   |    +----------------+
	             +---------+                |     +---------+  +---------+  +---------+       |   |
	             |ApiServer|                |     |   Node  |  |   Node  |  |   Node  |  -----+   |       
	             |         |                |     |         |  |         |  |         |           |    +----------------+   
	             +---------+                      +---------+  +---------+  +---------+                |  DB            |  
	      +---------+     +---------+             +---------+  +---------+  +---------+  -----------|> |                |  
	      | Manager |     |Scheduler|   -----|>   |   Node  |  |   Node  |  |   Node  |                +----------------+ 
	      |         |     |         |             |         |  |         |  |         |           |     
	      +---------+     +---------+       |     +---------+  +---------+  +---------+           |
	 +---------+  +---------+  +---------+  |     +---------+  +---------+  +---------+           |    +----------------+ 
	 |   Etcd  |  |   Etcd  |  |   Etcd  |  |     |   Node  |  |   Node  |  |   Node  |           |    | Cache          | 
	 |         |  |         |  |         |  |     |         |  |         |  |         |           |    |    ....        | 
	 +---------+  +---------+  +---------+  |     +---------+  +---------+  +---------+           |    +----------------+ 
	                                        |                                                     |
	     3.最高安全级别区域,                |     2. 公网用户的请求经由LB转发到Node，             |   4.其他的独立的内部服务
	       控制器与Node之间有严格的网络管制 |        公网用户看不到Node的IP。                     |
                                                


## 场景3 - Pods之间如何实现通信

在Kubernetes的设计中，对网络有如下的假定:

	1. all containers can communicate with all other containers without NAT
	2. all nodes can communicate with all containers (and vice-versa) without NAT
	3. the IP that a container sees itself as is the same IP that others see it as

也就是说，所有的Pods(Kubernetes中Pods是具有独立IP的最小单位，同一个Pods中的容器共用一个IP)和Nodes在网络中具有等同的地位，有各自的网络地址而且互相联通。

Kubernetes只提出这种要求，完全不关心的要怎样实现，这个问题其实是部署Kubernetes的用户自己需要考虑的问题。

这就是一个开放性问题了，可以有各种各样的实现。找任何一家网络厂商，他们都会告诉你他们的独特之处。即使不想依赖于硬件，各种开源sdn实现也为数不少。

满足了Kubernetes的上述要求之后，很有可能又会遇到需要网络隔离的场景，这个场景就有点棘手了，Kubernetes必须能够与底层的网络进行联动。

这个问题太大，这里不展开，等在这方面有了比较充足的积累之后，单独成篇。

## 文献
