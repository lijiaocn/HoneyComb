---
layout: default
title: 2_example_namespace

---

# 2_example_namespace
创建时间: 2015/07/02 18:39:51  修改时间: 2015/07/02 19:45:56 作者:lijiao

----

## 摘要

[本篇示例](../examples/2-namespace)

通过[第一篇 在Kubernetes中使用Redis](./doc/1_example_redis.md)，已经基本了解到Kubernetes的目标和基本的使用方式。但是第一篇没有提到下面的问题：

	1. 服务的IP是以环境变量方式设置的，如果服务特别多，那么岂不是将会有太多的环境变量，即使是用不着的？

	2. 我创建了一个服务，但是这个服务只是我自己用，我不想任其他人看到，要怎样做？

Kubernetes中通过Namespace不仅解决了这两个问题，而且可以让你创建任意多的彼此隔离的环境。

## 创建Namespace

首先查看下默认的Namespace，可以看到默认只有一个名为default的Namespace。

	$ ./kubectl-dev.sh get namespace
	NAME      LABELS    STATUS
	default   <none>    Active

然后，我们创建两个Namespace, 分别命名为example-2-dev(development env)和example-2-prod(produce env)，可以看到系统中多了两个Namespace:

	$./0_create_namespace.sh
	namespaces/example-2-dev
	namespaces/example-2-prod
	NAME             LABELS                STATUS
	default          <none>                Active
	example-2-dev    name=example-2-dev    Active
	example-2-prod   name=example-2-prod   Active


[example-2-dev](../examples/2-namespace/json/0_namespace.dev.json)的描述文件:


	{
	  "kind": "Namespace",
	  "apiVersion": "v1beta3",
	  "metadata": {
		"name": "example-2-dev",
		"labels": {
		  "name": "example-2-dev"
		}
	  }
	} 

[example-2-prod](../examples/2-namespace/json/0_namespace.prod.json)的描述文件:

	{
	  "kind": "Namespace",
	  "apiVersion": "v1beta3",
	  "metadata": {
		"name": "example-2-prod",
		"labels": {
		  "name": "example-2-prod"
		}
	  }
	} 

接下来，我们分别在不同的Namespace中创建Kubernetes对象，查看有没有实现隔离。

使用不同的Namespace时，只需在kubectl命令后指定参数"--namespace=XXX"，XXX是目标Namespace的名称。

为了方便，这里写了两个脚本，[kubectl-dev](../examples/2-namespace/kubectl-dev.sh)和[kubectl-prod](../examples/2-namespace/kubectl-prod.sh)，分别用于example-2-dev和example-2-prod。

## example-2-dev: 创建Service

这里使用的镜像和第一篇中的相同，镜像的具体作用可以回到[第一篇](./doc/1_example_redis.md)查看。

	 $./kubectl-dev.sh create -f json/1_1_pod.redis_master.json 
	 $./kubectl-dev.sh create -f json/1_2_service.redis_master.json
	 $./kubectl-dev.sh create -f json/4_1_sleep.json 

使用kubectl-dev可以查看到以下Pod和Service:

	$ ./kubectl-dev.sh get pods
	POD            IP        CONTAINER(S)   IMAGE(S)                                                    HOST               LABELS                   STATUS    CREATED     MESSAGE
	redis-master                                                                                        192.168.200.164/   name=redis,role=master   Pending   16 months   
							redis-master   192.168.202.240:5000/lijiao/example-1-redis-master:2.8.19                                                                     
	sleep                                                                                               192.168.200.164/   name=sleep               Pending   16 months   
							sleep          192.168.202.240:5000/lijiao/example-1-sleep                                                                                   


	$ ./kubectl-dev.sh get service
	NAME           LABELS                   SELECTOR                 IP(S)           PORT(S)
	redis-master   name=redis,role=master   name=redis,role=master   172.16.82.126   6379/TCP

而在example-1-prod环境就看不到这些内容:

	$ ./kubectl-prod.sh get pods
	POD       IP        CONTAINER(S)   IMAGE(S)   HOST      LABELS    STATUS    CREATED   MESSAGE


	$ ./kubectl-prod.sh get service
	NAME      LABELS    SELECTOR   IP(S)     PORT(S)

到192.168.200.164上查看sleep导出的环境变量文件，可以到redis-master service的服务地址:

	REDIS_MASTER_PORT=tcp://172.16.82.126:6379                   <---在这里
	REDIS_MASTER_SERVICE_PORT=6379
	REDIS_MASTER_PORT_6379_TCP_ADDR=172.16.82.126
	REDIS_MASTER_PORT_6379_TCP_PORT=6379
	REDIS_MASTER_PORT_6379_TCP_PROTO=tcp
	KUBERNETES_PORT_443_TCP_PORT=443
	KUBERNETES_RO_SERVICE_PORT=80
	KUBERNETES_RO_PORT=tcp://172.16.0.1:80
	KUBERNETES_PORT_443_TCP_PROTO=tcp
	KUBERNETES_RO_PORT_80_TCP_ADDR=172.16.0.1
	KUBERNETES_PORT_443_TCP=tcp://172.16.0.2:443
	KUBERNETES_RO_PORT_80_TCP_PORT=80
	KUBERNETES_SERVICE_HOST=172.16.0.2
	KUBERNETES_RO_PORT_80_TCP_PROTO=tcp

## example-2-prod: 容器中是否能看到其他Namespace中的服务

我们在example-2-prod中创建一个sleep:

	$ ./kubectl-prod.sh create -f ./json/4_1_sleep.json 
	pods/sleep


	$ ./kubectl-prod.sh get pods
	POD       IP        CONTAINER(S)   IMAGE(S)                                      HOST               LABELS       STATUS    CREATED     MESSAGE
	sleep                                                                            192.168.200.165/   name=sleep   Pending   16 months   
	                    sleep          192.168.202.240:5000/lijiao/example-1-slee

可以看到，我们能够在example-2-prod中看到我们新建的sleep，即使与example-1-prod中的sleep重名也可以创建成功。(在exampe-2-dev是看不到这个新建的sleep的)

查看这个新的sleep导出的环境变量文件，可以看到其中没有redis-master service的服务地址:

	[root@localhost Data]# cat env.log 
	KUBERNETES_PORT=tcp://172.16.0.2:443
	KUBERNETES_SERVICE_PORT=443
	KUBERNETES_RO_PORT_80_TCP=tcp://172.16.0.1:80
	HOSTNAME=sleep
	HOME=/root
	KUBERNETES_RO_SERVICE_HOST=172.16.0.1
	KUBERNETES_PORT_443_TCP_ADDR=172.16.0.2
	PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
	KUBERNETES_PORT_443_TCP_PORT=443
	KUBERNETES_RO_SERVICE_PORT=80
	KUBERNETES_RO_PORT=tcp://172.16.0.1:80
	KUBERNETES_PORT_443_TCP_PROTO=tcp
	KUBERNETES_RO_PORT_80_TCP_ADDR=172.16.0.1
	KUBERNETES_PORT_443_TCP=tcp://172.16.0.2:443
	KUBERNETES_RO_PORT_80_TCP_PORT=80
	KUBERNETES_SERVICE_HOST=172.16.0.2
	KUBERNETES_RO_PORT_80_TCP_PROTO=tcp
	PWD=/dat]

## 结束

通过上面的示例，我们可以看到Namespace将两个环境隔离开来，一个Namespace中的容器只能看到隶属同一个Namespace的服务。

细心的你可能发现两个sleep导出的环境文件中，都存在一个名为KUBERNETES_RO_PORT变量，这个变量是Kubernetes自身的一个服务，位于默认的Namespace——"default"中。

因此如果希望所有的容器都能看到某个服务，可以把它放入“default“中。

## 文献
