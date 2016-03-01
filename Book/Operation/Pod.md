---
layout: default
title: Pod

---

# Pod
创建时间: 2016/02/24 16:25:09  修改时间: 2016/03/01 19:26:58 作者:lijiao

----

## 摘要

创建第一个pod。

## 准备镜像

这里准备一个镜像，启动后，开启sshd服务，然后进行sleep状态。

	$ git clone https://github.com/lijiaocn/SSHProxy.git
	$ cd SSHPROXY
	$ ./build.sh
	$ sudo docker tag sshproxy:1.0  registry.local:5000/sshproxy:1.0
	$ sudo docker push registry.local:5000/sshproxy:1.0
	
检查registry.local中是否已经存在sshproxy

	$ cd Tools
	$./registry.sh repo
	{"repositories":["kubernetes/pause","sshproxy"]}
	
	$./registry.sh tags sshproxy
	{"name":"sshproxy","tags":["1.0"]}

## 创建pod

	$ cd cmd-kubectl/secure/admin-super
	$../kubectl.sh create -f ../../../../../Operation/api-v1-example/pod-sshproxy.json
	$ ../kubectl.sh get pods --namespace=first-namespace
	NAME       READY     STATUS    RESTARTS   AGE
	sshproxy   1/1       Running   0          5d

Pod文件说明:

	{
	  "kind": "Pod",
	  "apiVersion": "v1",
	  "metadata": {
	    "name": "sshproxy",
	    "namespace": "first-namespace",
	    "deletionGracePeriodSeconds": 5,
	    "labels": {
	        "type": "Independent",
	        "name":"sshproxy",
	        "owner":"first-namespace"
	    },
	    "annotations": {
	        "describe": "just sshd servcie"
	    }
	  },
	  "spec": {
	    "containers": [
	      {
	        "name": "sshproxy",
	        "image": "registry.local:5000/sshproxy:1.0",     //容器镜像
	        "env": [                                         //sshproxy启动时会使用这几个环境变量设置用户密码
	          {
	            "name": "ROOTPASS",
	            "value": "123456"
	          }
	        ],
	        "resources": {           
	          "limits": {              //容器可以使用的资源上限
	              "cpu": 3.0,
	              "memory": "128Mi"
	          },
	          "requests": {            //容器至少需要的资源
	              "cpu": 1.0,
	              "memory": "32Mi"
	          }
	        },
	        "livenessProbe": {         //容器存活探测方式
	          "tcpSocket": {
	            "port": 22
	          },
	          "initialDelaySeconds": 5,
	          "timeoutSeconds": 5
	        },
	        "imagePullPolicy": "Always",  //容器每次启动都重新拉去镜像
	        "securityContext": {
	          "privileged": false,
	          "runAsNonRoot": false
	        },
	        "stdin": false,
	        "stdinOnce": false,
	        "tty": false
	      }
	    ],
	    "restartPolicy": "Never",      //容器死掉之后知否重启
	    "dnsPolicy": "Default",
	    "serviceAccountName": "default",
	    "hostNetwork": false,
	    "hostPID": false,
	    "hostIPC": false
	  }
	}




## 文献
