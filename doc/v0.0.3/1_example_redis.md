---
layout: default
title: 1_example_redis

---

# 1_example_redis
创建时间: 2015/07/01 09:53:14  修改时间: 2015/07/02 19:35:51 作者:lijiao

----

## 摘要

这里介绍了如何在Kubernetes中部署使用Redis.

资料: [example1](../examples/1-redis/)

## 名词

Pod: 在一台宿主机上运行的一组容器， Pod内容器共用一个Net Namespace, 也就是说每个Pod才有一个独立的IP。 

RC: 多个Pod的组合，Kubernetes保证一个RC中Pod的数量，如果某个Pod丢失，自动新建一个Pod保证Pod总数不变。

Service: 多个Pod的组合，Service有自己的一个IP，对Service的IP的访问，将被转发组成Service的Pod上。

## 检查

首先检查下Node是否正常:

	$ ./kubectl.sh get nodes
	NAME              LABELS                                   STATUS
	192.168.200.164   kubernetes.io/hostname=192.168.200.164   Ready
	192.168.200.165   kubernetes.io/hostname=192.168.200.165   Ready
	192.168.200.166   kubernetes.io/hostname=192.168.200.166   Ready
	192.168.200.167   kubernetes.io/hostname=192.168.200.167   Ready
	192.168.200.168   kubernetes.io/hostname=192.168.200.168   Ready

查看已有的Pod，防止干扰:

	$ ./kubectl.sh get pods
	POD       IP        CONTAINER(S)   IMAGE(S)   HOST      LABELS    STATUS    CREATED   MESSAGE

## 规划

[deploy](../examples/1-redis/deploy):

	      +--------------+      +--------------+
	      | Web Server 1 |      | Web Server 2 |   <--- Web Server Service(包含Web Server RC中的Pods)
	      +--------------+      +--------------+
	          |   |
	          |   -----------+
	          |             _|_
	          |             \ /
	          |       +------'------+
	          |       | redis master|              <--- Redis Master Service(只包含一个Redis Master Pod)
	          |       +-------------+
	         _|_
	         \ /
	   +------'--------+             +---------------+
	   | redis slave 1 |             | redis slave 2 |   <--- Redis Slave Service(包含Redis Slave RC中的Pods)
	   +---------------+             +---------------+

Web Server Service --(依赖)-->Redis Master Service & Reids Slave Service 。

Reids Slave Service --(依赖)-->Redis Master Service 。

所以首先部署Redis Master Service，然后部署Redis Slave Service，最后部署Web Server Service。

Web Server Service 如何知晓Redis Master Service 和Redis Slave Service 的地址，以及Redis Slave Service 如何知晓Redis Master Service的地址?

	Kubernetes中有两种方案，一种是通过环境变量通知(下面采用的方案),另一种通过DNS(Kubernetes还在开发此功能)。

在下面的示例中，还使用了一个名为Sleep的Pod，这个Pod用来辅助查看容器可见的环境变量, 不依赖上述的任何服务，可以随时启用。

## 准备镜像

[build](../examples/1-redis/build.sh)中创建了所有需要的镜像。镜像的细节在下面相关章节展开。

## 镜像说明

### Redis Master

[Redis Master](../examples/1-redis/redis-master)的就是单纯的启动一个redis-server。

[Dockerfile](../examples/1-redis/redis-master/Dockerfile):

	FROM 192.168.202.240:5000/lijiao/example-1-redis:2.8.19

	ADD etc_redis_redis.conf /etc/redis/redis.conf

	CMD ["redis-server", "/etc/redis/redis.conf"]
	# Expose ports.
	EXPOSE 6379

在Kubernetes中创建一个[Redis Master Pod](../examples/1-redis/json/1_1_pod.redis_master.json)。

在Kubernetes中创建一个[Redis Master Service](../examples/1-redis/json/1_2_service.redis_master.json)。

之后我们应当能够在容器中看到Redis Master Service相关的环境变量(服务名称为redis-master):

	REDIS_MASTER_SERVICE_HOST -- "redis-master"'s virtual ip address  eg. 10.0.0.11
	REDIS_MASTER_SERVICE_PORT -- "redis-master"'s service port        eg. 6379
	REDIS_MASTER_PORT         -- "redis-master"'s service address     eg. tcp://10.0.0.11:6379

	#if the service port is 6379:
	REDIS_MASTER_PORT_6379_TCP        -- eg. tcp://10.0.0.11:6379
	REDIS_MASTER_PORT_6379_TCP_PROTO  -- eg. tcp
	REDIS_MASTER_PORT_6379_TCP_PORT   -- eg. 6379
	REDIS_MASTER_PORT_6379_TCP_ADDR   -- eg. 10.0.0.11

### Redis Slave

[Redis Slave](../examples/1-redis/redis-slave)作为Redis Master的Slave。

[Dockerfile](../examples/1-redis/redis-slave/Dockerfile):

	FROM 192.168.202.240:5000/lijiao/example-1-redis:2.8.19
	ADD run.sh /run.sh
	CMD /run.sh

[run.sh](../examples/1-redis/redis-slave/run.sh):

	echo "Note, if you get errors below indicate kubernetes env injection could be faliing..."
	echo "env vars ="
	env
	echo "CHECKING ENVS BEFORE STARTUP........"
	if [ ! "$REDIS_MASTER_SERVICE_HOST" ]; then
		echo "Need to set REDIS_MASTER_SERVICE_HOST" && exit 1;
	fi
	if [ ! "$REDIS_MASTER_PORT" ]; then
		echo "Need to set REDIS_MASTER_PORT" && exit 1;
	fi

	echo "ENV Vars look good, starting !"

	redis-server --slaveof ${REDIS_MASTER_SERVICE_HOST:-$SERVICE_HOST} $REDIS_MASTER_SERVICE_PORT

>注意: 在run.sh中通过读取环境变量REDIS_MASTER_SERVICE_HOST,得知Master的地址, 注意，这是在容器内。

[Redis Slave Service](../examples/1-redis/json/2_2_service.redis_slave.json)由一个[Redis Slave RC](../examples/1/json/2_1_controller.redis_slave.json)组成。

而Redis Slave RC由两个Redis Slave Pod组成(在RC的创建文件里指明)，Kubernetes保证始终有两个Redis Slave Pod存在，这两个Pod共同承担用户的请求。

### Sleep

[Sleep](../examples/1-redis/sleep)用来帮助我们查看容器内的环境变量:

[Dockerfile](../examples/1-redis/sleep/Dockerfile)

	FROM 192.168.202.240:5000/lijiao/base-os:1.0
	CMD env 1>/export/Data/env.log 2>&1 && sleep 1000000

Sleep运行时将能够看到的环境变量保存到了/export/Data/env.log中, 在创建Sleep Pod时，可以将宿主机上的一个目录挂载到容器内部的/export/Data，这样就可以直接在宿主机上查看env.log。Pod如下:

>这也代表了Kubernetes中存储的使用方式。Kubernetes已经支持挂载多种文件系统(gce、aws、nfs、iscsi、glusterfs等)。

[Sleep Pod](../examples/1-redis/json/4_1_sleep.json):

	{
		"kind": "Pod",
		"apiVersion": "v1beta3",
		"id": "sleep",
		"metadata":{
			"name":"sleep",
			"labels":{
				"name":"sleep"
			}
		},
		"spec":{
			"volumes":[
			{
				"name":"exportdata",
				"hostPath":               <---类型:宿主机目录
				{
					"path":"/export/Data/"
				}
			}
			],
			"containers":[
			{
				"name":"sleep",
				"image":"192.168.202.240:5000/lijiao/example-1-sleep",
				"imagePullPolicy":"IfNotPresent",
				"volumeMounts":[         <-- 容器内的挂载
				{
					"name":"exportdata",
					"readOnly":false,
					"mountPath":"/export/Data"
				}
				]
			}
			],
			"restartPolicy": "Always",
			"dnsPolicy":"ClusterFirst"
		}
	}

## 提交到Kubernetes

依次执行[example1](../examples/1-redis)中的脚本:

	$./1_1_redis_master_pod.sh
	$./1_2_redis_master_service.sh

然后我们先创建一个Sleep Pod，查看在容器中都可以看到哪些环境变量:

	$./4_1_sleep_pod.sh

执行./kubectl.sh get pods，我们可以

	$./kubectl.sh get pods
	POD            IP             CONTAINER(S)   IMAGE(S)                                                    HOST                              LABELS                   STATUS    CREATED              MESSAGE
	redis-master   172.16.126.3                                                                              192.168.200.164/192.168.200.164   name=redis,role=master   Running   16 months            
	                              redis-master   192.168.202.240:5000/lijiao/example-1-redis-master:2.8.19                                                              Running   Less than a second   
	sleep          172.16.125.3                                                                              192.168.200.166/192.168.200.166   name=sleep               Running   16 months            
	                              sleep          192.168.202.240:5000/lijiao/example-1-sleep   

可以看到sleep的容器运行在宿主机192.168.200.166上，我们登录上去查看宿主机上的/export/Data/env.log:

	[root@localhost Data]# cat env.log 
	KUBERNETES_PORT=tcp://172.16.0.2:443
	KUBERNETES_SERVICE_PORT=443
	KUBERNETES_RO_PORT_80_TCP=tcp://172.16.0.1:80
	REDIS_MASTER_SERVICE_HOST=172.16.23.190
	HOSTNAME=sleep
	HOME=/root
	REDIS_MASTER_SERVICE_PORT=6379                          
	REDIS_MASTER_PORT=tcp://172.16.23.190:6379           <--- 注意到了没有？这就是Redis Master Service的地址
	REDIS_MASTER_PORT_6379_TCP_ADDR=172.16.23.190
	REDIS_MASTER_PORT_6379_TCP_PORT=6379
	REDIS_MASTER_PORT_6379_TCP_PROTO=tcp
	KUBERNETES_RO_SERVICE_HOST=172.16.0.1
	KUBERNETES_PORT_443_TCP_ADDR=172.16.0.2
	PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
	KUBERNETES_PORT_443_TCP_PORT=443
	KUBERNETES_RO_SERVICE_PORT=80
	KUBERNETES_RO_PORT=tcp://172.16.0.1:80
	KUBERNETES_PORT_443_TCP_PROTO=tcp
	REDIS_MASTER_PORT_6379_TCP=tcp://172.16.23.190:6379
	KUBERNETES_RO_PORT_80_TCP_ADDR=172.16.0.1
	KUBERNETES_PORT_443_TCP=tcp://172.16.0.2:443
	KUBERNETES_RO_PORT_80_TCP_PORT=80
	KUBERNETES_SERVICE_HOST=172.16.0.2
	KUBERNETES_RO_PORT_80_TCP_PROTO=tcp
	PWD=/data

>注意区别Redis Master Service的地址和Redis Master Pod的地址，这两个地址是不同的, 对Redis Master Service的访问按照一定策略被转发给Redis Master Pod。(Kubernetes就是这样实现了负载均衡)

然后可以把Sleep Pod删除，在Redis Slave Service创建后重建:

	$./kubectl.sh delete pods sleep
	$./2_1_redis_slave_controller.sh
	$./2_2_redis_slave_service.sh
	$./4_1_sleep_pod.sh

重新查看,应该可以看到REDIS_SLAVE_PORT等环境变量.

最后启动Web Server:

	$./3_1_webserver_controller.sh
	$./3_2_webserver_service.sh

## 文献


