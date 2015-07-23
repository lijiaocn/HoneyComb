---
layout: default
title: 0_release_0.0.2

---

# 0_release_0.0.2
创建时间: 2015/07/22 09:45:15  修改时间: 2015/07/23 15:01:28 作者:lijiao

----

## 摘要

0.0.2中, 对HoneyComb的编译打包方式了做了较大修改, 在Config中针对每个集群建立了一个目录，目录里包含的是针对这个集群的配置。

发布包命名规则为“集群名-版本--宿主机系统-版本--HoneyComb-版本.tar.gz”，打包完成后存放到目录“Release”中。

新的编译打包脚本“release.sh”

## 目录说明

	$ tree  -L 1
	.
	|-- Config         #按集群分开的配置文件
	|-- doc            #文档
	|-- examples       #K8s使用示例
	|-- README.md
	|-- Release        #发布包
	|-- release.sh     #打包编译脚本
	|-- Shell          #HoneyComb的核心
	|-- ThirdParty     #编译时下载的依赖项目的Git代码库
	|-- TODO
	|-- Tools          #一些便利工具


## 使用

假设要在一个名为“cluster1”的集群上部署HoneyComb。

到Config目录中创建一个同名目录cluster1:

	$ tree Config/
	Config/
	`-- cluster1
		|-- base.sh         #Cluster1的编排,用法与0.0.1一致
		|-- config          #针对Cluster1的配置, 设置了组件的版本
		|-- flannel.json    #Cluster1的flannel配置
		`-- machines.lst    #Cluster1的结点

### 编辑machines.lst

machines.lst中只是记录了组成集群的节点的地址, 一些便利工具会利用这里面的信息, 完成对整个集群的操作。

	#CentOS 6.4 VM CPU 4 Memory 8G Disk 100G
	root@192.168.202.240
	root@192.168.202.241
	root@192.168.202.242

	#CentOS 7.1 PHY CPU 32 Memeory 32G Disk 792G
	root@192.168.183.59
	root@192.168.183.60
	root@192.168.183.61
	root@192.168.183.62
	root@192.168.183.63
	root@192.168.183.64
	root@192.168.183.65

cluster1总共有10个节点。

后面章节使用batch.sh对node进行批量操作的时候, 是按照node在machines.lst中的出现的先后顺序执行的。

用batch.sh的start指令启动整个集群的时候，对node启用的先后顺序有要求，所以machine.lst中的地址信息需要按照etcd、apiserver、manager、scheduler、node的顺序排列。

### 编辑base.sh

base.sh描述了cluster1的编排。(发布包中, Shell中的base.sh等文件会被对应cluster中的同名文件覆盖)

	...(省略)...

	#docker
	DOCKER_REGISTRYS="192.168.202.240:5000"
	DOCKER_INSECURES="0.0.0.0/0"
	
	#etcd Nodes
	declare -a ARRAY_ETCD_NODES
	ARRAY_ETCD_NODES[0]="192.168.202.241"
	ARRAY_ETCD_NODES[1]="192.168.202.242"
	
	#kubernete ApiServer Nodes
	declare  -a ARRAY_API_SERVER_NODES
	ARRAY_API_SERVER_NODES[0]="192.168.183.59"
	
	#kubernete controller manager Nodes
	declare  -a ARRAY_MANAGER_NODES
	ARRAY_MANAGER_NODES[0]="192.168.183.60"
	
	#kubernete  scheduler Nodes
	declare  -a ARRAY_SCHEDULER_NODES
	ARRAY_SCHEDULER_NODES[0]="192.168.183.61"
	
	#kubernete Nodes
	declare  -a ARRAY_KUBE_NODES
	ARRAY_KUBE_NODES[1]="192.168.183.62"
	ARRAY_KUBE_NODES[2]="192.168.183.63"
	ARRAY_KUBE_NODES[3]="192.168.183.64"
	ARRAY_KUBE_NODES[4]="192.168.183.65"
	
	#kubenetes master
	#TODO
	#It should be a api server list. but kubernete maybe haven't finish this work
	MASTER_SERVER="http://192.168.183.59:8080"

	...(省略)...

把节点的IP填到对应位置即可(1台作为Registry, 2台etcd, 1台apiserver, 1台manager, 1台scheduer, 4台Node)。

这个示例中，cluster1的最终编排如下:

	   +-----------------+     
	   |     Registry    |
	   | 192.168.202.240 |
	   +-----------------+
	                          +------------------+      +------------------+
	                          |       etcd       |      |       etcd       |
	                          |  192.168.202.241 |      |  192.168.202.242 |
	                          +------------------+      +------------------+
	                                      ^                   ^
	                                      |                   |
	                                      +----------+--------+
	                                                 |
	           +------------------+         +------------------+         +------------------+ 
	           |     master       |------|> |     apiserver    | <|------|    scheduler     | 
	           |  192.168.183.60  |         |  192.168.183.59  |         |  192.168.183.61  | 
	           +------------------+         +------------------+         +------------------+ 
	                                                 ^
	                                                 |
	                                                 v      
	           +-------------------------+-----------------------+----------------------+
	           |                         |                       |                      |
	   +----------------+       +----------------+      +----------------+      +----------------+
	   |     node       |       |     node       |      |     node       |      |     node       |
	   | 192.168.183.62 |       | 192.168.183.63 |      | 192.168.183.64 |      | 192.168.183.65 |
	   +----------------+       +----------------+      +----------------+      +----------------+

### 配置config

config中配置了依赖的组件的版本，release.sh按照这里的设定去拉取、编译各个组件。

	SelfVersion=0.0.1

	K8sUrl=https://github.com/GoogleCloudPlatform/kubernetes.git
	K8sTag=v1.0.0

	FlannelUrl=https://github.com/coreos/flannel.git
	FlannelTag=v0.4.1

	EtcdUrl=https://github.com/coreos/etcd.git
	EtcdTag=v2.0.11

SelfVersion是cluster1自己的版本。

### 配置组件

不同的集群可能对组件有不同的设置，0.0.2中只有flannel有单独设置(flannel.json)。

	{
		"Network":"172.16.0.0/16",
			"Subnetlen":24,
			"SubnetMin":"172.16.100.100",
			"SubnetMax":"172.16.254.254",
			"Backend":{
				"Type":"udp",
				"Port":7890
			}
	}

### 打包发布

打包发布之前, 先核实version中的信息:

	$ cat version 
	HoneyCombVersion=0.0.2
	HostSystem=CentOS-7.1.1503

version中的信息会用来命名发布包。HostSystem是执行编译的机器的系统版本。

编译打包:

	$./release.sh 
	cluster1
	Choose the Cluster:cluster1               <---输入cluster1
	Start Compile ./ThirdParty/Kubernetes:    <---开始拉取编译各个组件
		https://github.com/GoogleCloudPlatform/kubernetes.git
			v1.0.0
			Previous HEAD position was cd82144... Kubernetes version v1.0.0
			Switched to branch 'master'
	...(省略)...

完成后:

	$ tree Release/
	Release/
	|-- cluster1-0.0.1--CentOS-7.1.1503--HoneyComb-0.0.2.sha1sum
	`-- cluster1-0.0.1--CentOS-7.1.1503--HoneyComb-0.0.2.tar.gz

如果集群中有多个版本的操作系统, 那么需要针对每个系统版本编译一次。

例如cluster1中有CentOS 6.4和CentOS 7.1两个系统版本:

	1. 需要在CentOS 6.4上制作一个cluster1-0.0.1-CentOS-6.4--HoneyComb-0.0.2.tar.gz
	2. 需要在CentOS 7.1上制作一个cluster1-0.0.1-CentOS-7.1--HoneyComb-0.0.2.tar.gz

>后续版本中可能会将编译环境保存到docker镜像中, 从而可以在一台编译机上编译多个版本。

### 安装

将得到的发布包拷贝到目标机器上后，解压，拷贝到目标机的/export目录中。

	tar -xvf cluster1-0.0.1--CentOS-7.1.1503--HoneyComb-0.0.2.tar.gz 
	/bin/cp -rf cluster1-0.0.1--CentOS-7.1.1503--HoneyComb-0.0.2/export/*   /export/

>在0.0.1中提供了一个自动检测安装的脚本, 但是感觉不好。0.0.2中取消了这个功能, 等这方面有想法后在后续版本中再添加。

在Tools中提供了一个batch.sh脚本(依赖expect)， 可以对cluster中的所有节点依次进行同样的操作，例如：

	$ ./batch.sh uname -a            <-- 执行命令"uname -a"
	cluster1                         <-- 可以操作的cluster
	Choose the Cluster:cluster1      <-- 选择一个cluster
	PASSWORD:                        <-- 输入密码
	spawn ssh root@192.168.202.240 uname -a
	root@192.168.202.240's password: 
	Linux localhost.localdomain 2.6.32-358.el6.x86_64 #1 SMP Fri Feb 22 00:31:26 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux
	spawn ssh root@192.168.202.241 uname -a
	Linux localhost.localdomain 2.6.32-358.el6.x86_64 #1 SMP Fri Feb 22 00:31:26 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux
	...(省略)...

使用batch.sh中的upload命令, 将发行包传送到所有节点的/root/upload目录中:

	$./batch.sh upload ../Release/cluster1-0.0.1--CentOS-7.1.1503--HoneyComb-0.0.2.tar.gz   
	cluster1
	Choose the Cluster:cluster1
	PASSWORD:
	spawn scp -r ../Release/cluster1-0.0.1--CentOS-7.1.1503--HoneyComb-0.0.2.tar.gz root@192.168.202.240:/root/upload/
	root@192.168.202.240's password: 
	cluster1-0.0.1--CentOS-7.1.1503--HoneyComb-0.0.2.tar.gz                                                            100%   41MB  40.6MB/s   00:00 
	spawn scp -r ../Release/cluster1-0.0.1--CentOS-7.1.1503--HoneyComb-0.0.2.tar.gz root@192.168.202.241:/root/upload/

使用batch.sh进行安装:

	./batch.sh "cd /root/upload &&  tar -xvf cluster1-0.0.1--CentOS-7.1.1503--HoneyComb-0.0.2.tar.gz &&/bin/cp -rf  cluster1-0.0.1--CentOS-7.1.1503--HoneyComb-0.0.2/export/* /export/"

>注意batch.sh一次只能执行一条指令, 但是可以用"&&"将很多操作融合成一条指令（不能用分号，会报错）。

### 节点调试

将HoneyComb安装到节点上之后，还不能立即启动，还需要针对节点做一些调试。比如/export/Shell/flanneld.sh中:

	declare -A Configs
	Configs[iface]="-iface=eth0"   <--- iface需要根据节点情况进行配置

把/export/Shell/中的下列文件检查一遍：

	apiserver.sh  docker.sh  etcd.sh  flanneld.sh  kubelet.sh  kube-proxy.sh  manager.sh  scheduler.sh

确认无误后, 执行run.sh:

	cd /export/Shell;
	./run.sh     

日志记录在/export/Logs中，如果run.sh没有报错，执行stop.sh

	cd /export/Shell;
	./stop.sh     

同样没有报错，那么这个节点就可以投入使用了, 将所有的节点投入使用后，整个集群就开始运转。

节点之间存在下面的依赖关系，调试节点的时候应该注意:
	
	                            +----------+
	                            |   etcd   |
	                            +----------+
	                                  ^
	                                  |
	                            +-----------+
	                            | apiserver |
	                            +-----------+
	                             ^     ^    ^
	                             |     |    |
	          +------------------+     |    +------------------+
	          |                        |                       |
	   +--------------+        +--------------+        +--------------+ 
	   |    master    |        |   scheduler  |        |     nodes    | 
	   +--------------+        +--------------+        +--------------+ 

>0.0.2还缺少一个stat.sh, 用来查看节点的状态。

### 集群的启动/关闭

可以向上一节中那样, 逐个节点的启动/关闭。

也可以使用batch.sh直接启动/关闭集群(前提是各个节点已经调试通过):

	./batch.sh  start
	./batch.sh  stop

>batch.sh现在通过密码访问节点，要求所有节点的密码相同。以后可以改成用私钥登录。

### 管理K8s集群

Tools/kubectl.sh用来管理K8s集群:

	cd Tools;

	$ ./kubectl.sh get nodes
	NAME             LABELS                                  STATUS
	192.168.183.62   kubernetes.io/hostname=192.168.183.62   Ready
	192.168.183.63   kubernetes.io/hostname=192.168.183.63   Ready
	192.168.183.64   kubernetes.io/hostname=192.168.183.64   Ready
	192.168.183.65   kubernetes.io/hostname=192.168.183.65   Ready
	
	$ ./kubectl.sh get service
	NAME         LABELS                                    SELECTOR   IP(S)        PORT(S)
	kubernetes   component=apiserver,provider=kubernetes   <none>     172.16.0.1   443/TCP

## 存在的问题

问题1 需要为宿主机的每个系统版本准备一个编译环境

	后续版本中可能会将编译环境保存到docker镜像中, 从而可以在一台编译机上编译多个版本。

问题2 组件的命令参数随这版本的变化而变化

	K8s等还在快速的变化, 不同版本有不同的命令行参数，更换版本后需要重新调试节点。

问题3 怎样升级更新

	在0.0.1中提供了一个自动检测更新的脚本, 但是感觉不好。0.0.2中取消了这个功能, 等这方面有想法后在后续版本中再添加。

问题4 batch.sh使用密码登录节点

	batch.sh现在通过密码访问节点，要求所有节点的密码相同。以后可以改成用私钥登录。

问题5 配置不够精细

	0.0.2中做的配置很少, 主要还是用来搭建一个用来学习、试验的K8s集群。

## 文献


