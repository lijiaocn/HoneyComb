---
layout: default
title: Run

---

# Run
创建时间: 2016/02/03 17:55:38  修改时间: 2016/03/03 18:39:32 作者:lijiao

----

## 摘要

只需要在组件的目录中，运行以组件命名的脚本即可，例如：

	$./组件名.sh start
	$./组件名.sh stop
	$./组件名.sh restart

## 启动

依次启动安装好的组件。下面的示例中直接在Deploy/apiserver.local.secure中启动组件。

在Deploy/apiserver.local.secure的子目录依次执行以组件命名的脚本。

按照如下顺序启动组件:

	etcd --> flannel --> kube-apiserver --> kube-controller-manager 
	                                        kube-scheduler
	                                        kubelete
	                                        kube-proxy

启动过程:

	$ cd 1-etcd
	$ ./etcd.sh start
	
	$ cd 2-flannel
	$ ./net_init_config.sh     <-- 只有第一次启动的时候才需要
	$ sudo ./flannel.sh start
	
	$ cd 3-kube-apiserver
	$ sudo ./kube-apiserver.sh start
	
	$ cd 4-kube-controller-manager
	$ ./kube-controller-manager.sh start
	
	$ cd 5-kube-scheduler
	$ ./kube-scheduler.sh start
	
	$ cd 6-kube-proxy
	$ sudo ./kube-proxy.sh start
	
	$ cd 7-kubelet
	$ sudo ./kubelet.sh start
	
	$ cd 8-registry
	$ ./registry.sh start

每个组件默认在当前目录下生成一个log目录，里面记录有程序的标准输出和错误输出，以及操作历史，例如：

	▾ log/
		kube-apiserver.operate      //启动运行记录
		kube-apiserver.pid          //进程pid
		kube-apiserver.stderr       //错误输出
		kube-apiserver.stdout       //标准输出

## 检查

etcd中是否已经写入相关数据:

	$ cd cmd-etcdctl
	$ ./etcd.sh ls /kubernetes/secure
	/kubernetes/secure/apiserver
	/kubernetes/secure/flannel

	$ ./etcd.sh ls /kubernetes/secure/apiserver
	/kubernetes/secure/apiserver/services
	/kubernetes/secure/apiserver/events
	/kubernetes/secure/apiserver/minions
	/kubernetes/secure/apiserver/namespaces
	/kubernetes/secure/apiserver/ranges
	/kubernetes/secure/apiserver/secrets
	/kubernetes/secure/apiserver/serviceaccounts

kubenetes是否能够查看到node状态:

	$ cd cmd-kubectl/unsecure
	$ ./kubectl.sh get nodes
	NAME            LABELS                                 STATUS    AGE
	kubelet.local   kubernetes.io/hostname=kubelet.local   Ready     9d
	
	$ ./kubectl.sh get namespaces
	NAME      LABELS    STATUS    AGE
	default   <none>    Active    20d

查看认证授权是否有效:

	$ cd cmd-kubectl/secure/admin-super
	$ ../curl.sh nodes
	(省略返回的json文件)
	
	$ ../kubectl.sh get nodes
	 NAME            LABELS                                 STATUS    AGE
	 kubelet.local   kubernetes.io/hostname=kubelet.local   Ready     9d

在现在的版本里，kubectl会先去访问/api，获取api版本，但是当前版本只对资源做了权限控制，所以使用其它账号时会出现下面的问题:

	$ cd cmd-kubectl/secure/admin-cluster
	$ ../kubectl.sh get nodes
	error: couldn't read version from server: the server does not allow access to the requested resource
	
	$ ../kubectl.sh get nodes --v=10
	 I0224 02:33:05.497500    5565 debugging.go:102] curl -k -v -XGET  -H "User-Agent: kubectl/v1.1.7 (linux/amd64) kubernetes/e4e6878" https://apiserver.local/api
	 I0224 02:33:05.523127    5565 debugging.go:121] GET https://apiserver.local/api 403 Forbidden in 25 milliseconds
	 I0224 02:33:05.523176    5565 debugging.go:127] Response Headers:
	 I0224 02:33:05.523191    5565 debugging.go:130]     Content-Type: text/plain; charset=utf-8
	 I0224 02:33:05.523205    5565 debugging.go:130]     Date: Wed, 24 Feb 2016 02:33:05 GMT
	 I0224 02:33:05.523218    5565 debugging.go:130]     Content-Length: 17
	 I0224 02:33:05.523880    5565 request.go:746] Response Body: Forbidden: "/api"
	 I0224 02:33:05.523937    5565 request.go:803] Response Body: Forbidden: "/api"
	 F0224 02:33:05.525128    5565 helpers.go:96] error: couldn't read version from server: the server does not allow access to the requested resource

kubernetes的已经在解决这个问题了，可以暂时使用curl代替kubectl:

	$ cd cmd-kubectl/secure/admin-cluster
	$ ../kubectl.sh get nodes

## 文献
