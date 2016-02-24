---
layout: default
title: Prepare

---

# Prepare
创建时间: 2016/02/24 11:03:10  修改时间: 2016/02/24 15:07:12 作者:lijiao

----

## 摘要

为即将开始的操作做好准备。

## 确定pause镜像已经提交到registry

pause的镜像是Pod创建时需要的镜像，在kubelet的配置文件中指定:

	# The image whose network/ipc namespaces containers in each pod will use.
	CONFIGS[pod-infra-container-image]='--pod-infra-container-image="registry.local:5000/kubernetes/pause:latest'

需要确定registry.local:5000上存在该镜像:

	$ cd cmd-registry/
	./registry.sh repo
	{"repositories":[]}     <-- registry.local上没有pause镜像

提交pause镜像:

	$ cd Tools/Pause
	$./load.sh             <-- 加载镜像
	$./push.sh             <-- 推送到registry.local

再次核实:

	$ cd cmd-registry/
	
	./registry.sh repo
	{"repositories":["kubernetes/pause"]}
	
	./registry.sh tags kubernetes/pause
	{"name":"kubernetes/pause","tags":["latest"]}

## 查看组件状态

	 $../kubectl.sh get cs
	 NAME                 STATUS    MESSAGE              ERROR
	 controller-manager   Healthy   ok                   nil
	 scheduler            Healthy   ok                   nil
	 etcd-0               Healthy   {"health": "true"}   nil

## 确定节点状态就绪

	$ cd cmd-kubectl/secure/admin-super
	$ ../kubectl.sh get nodes
	NAME            LABELS                                 STATUS    AGE
	kubelet.local   kubernetes.io/hostname=kubelet.local   Ready     9d
	
	$ ../kubectl.sh get node kubelet.local -o yaml
	apiVersion: v1
	kind: Node
	metadata:
	  creationTimestamp: 2016-02-14T06:48:17Z
	  labels:
	    kubernetes.io/hostname: kubelet.local
	  name: kubelet.local
	  resourceVersion: "2152"
	  selfLink: /api/v1/nodes/kubelet.local
	  uid: edaf4f03-d2e6-11e5-9a61-080027d4b3b6
	spec:
	  externalID: kubelet.local
	status:
	  addresses:
	  - address: 192.168.40.99
	    type: LegacyHostIP
	  - address: 192.168.40.99
	    type: InternalIP
	  capacity:
	    cpu: "2"
	    memory: 4048220Ki
	    pods: "40"
	  conditions:
	  - lastHeartbeatTime: 2016-02-24T03:28:58Z
	    lastTransitionTime: 2016-02-14T06:48:17Z
	    message: kubelet has sufficient disk space available
	    reason: KubeletHasSufficientDisk
	    status: "False"
	    type: OutOfDisk
	  - lastHeartbeatTime: 2016-02-24T03:28:58Z
	    lastTransitionTime: 2016-02-24T02:07:50Z
	    message: kubelet is posting ready status
	    reason: KubeletReady
	    status: "True"
	    type: Ready
	  daemonEndpoints:
	    kubeletEndpoint:
	      Port: 10250
	  nodeInfo:
	    bootID: 71430226-c716-4719-a88d-bc8ef78244ad
	    containerRuntimeVersion: docker://1.6.2
	    kernelVersion: 3.13.0-71-generic
	    kubeProxyVersion: v1.1.7-dirty
	    kubeletVersion: v1.1.7-dirty
	    machineID: 2fa2c81aa0f3e8d660122d3156674158
	    osImage: Ubuntu 14.04.3 LTS
	    systemUUID: F1D56285-4EC8-431F-9C41-ACC5C9EDBA23

kubelet.local是节点的hostname，可以在kubelet的配置文件中设置:

	# If non-empty, will use this string as identification instead of the actual hostname.
	CONFIGS[hostname-override]='--hostname-override=kubelet.local'

## 确定default namespace是否存在

	$ cd cmd-kubectl/secure/admin-super
	$ ../kubectl.sh get nodes
	NAME      LABELS    STATUS    AGE
	default   <none>    Active    20d

## 准备要使用的资源文件

将会操作下面几种资源：

	pods (po)
	services (svc)
	replicationcontrollers (rc)
	nodes (no)
	events (ev)
	componentstatuses (cs)
	limitranges (limits)
	persistentvolumes (pv)
	persistentvolumeclaims (pvc)
	resourcequotas (quota)
	namespaces (ns)
	endpoints (ep)
	horizontalpodautoscalers (hpa)
	serviceaccounts
	secrets

Operation/api-v1-empty/中是v1版本的api中，每个资源的完整的空白json文件。

	$ls -l Operation/api-v1-empty/
	total 80
	-rw-r--r-- 1 vagrant vagrant  501 Feb  2 12:41 binding.json
	-rw-r--r-- 1 vagrant vagrant  501 Feb  2 12:41 bindings.json
	-rw-r--r-- 1 vagrant vagrant 1099 Feb  2 12:41 endpoints.json
	-rw-r--r-- 1 vagrant vagrant  673 Feb  2 12:41 events.json
	-rw-r--r-- 1 vagrant vagrant  561 Feb  2 12:41 limitranges.json
	-rw-r--r-- 1 vagrant vagrant  432 Feb  2 12:41 namespace.json
	-rw-r--r-- 1 vagrant vagrant 1240 Feb  2 12:41 nodes.json
	-rw-r--r-- 1 vagrant vagrant  588 Feb  2 12:41 persistentvolumeclaims.json
	-rw-r--r-- 1 vagrant vagrant 2156 Feb  2 12:41 persistentvolumes.json
	-rw-r--r-- 1 vagrant vagrant 8081 Feb  2 12:41 pods.json
	-rw-r--r-- 1 vagrant vagrant 7687 Feb  2 12:41 podtemplates.json
	-rw-r--r-- 1 vagrant vagrant 8444 Feb  2 12:41 replicationcontrollers.json
	-rw-r--r-- 1 vagrant vagrant  436 Feb  2 12:41 resourcequotas.json
	-rw-r--r-- 1 vagrant vagrant  376 Feb  2 12:41 secrets.json
	-rw-r--r-- 1 vagrant vagrant  586 Feb  2 12:41 serviceaccounts.json
	-rw-r--r-- 1 vagrant vagrant  846 Feb  2 12:41 services.json

Operation/api-v1-example/中是操作中使用的资源文件，已经配置好名称、镜像等内容。

## 文献
