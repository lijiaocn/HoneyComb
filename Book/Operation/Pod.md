---
layout: default
title: Pod

---

# Pod
创建时间: 2016/02/24 16:25:09  修改时间: 2016/03/02 18:23:53 作者:lijiao

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

## 查看Pod详情

	$../kubectl.sh get pods/sshproxy -o=json  --namespace=first-namespace
	{
	    "kind": "Pod",
	    "apiVersion": "v1",
	    "metadata": {
	        "name": "sshproxy",
	        "namespace": "first-namespace",
	        "selfLink": "/api/v1/namespaces/first-namespace/pods/sshproxy",
	        "uid": "300c8bb6-e05c-11e5-aa39-080027d4b3b6",
	        "resourceVersion": "25019",
	        "creationTimestamp": "2016-03-02T09:50:25Z",
	        "labels": {
	            "name": "sshproxy",
	            "owner": "first-namespace",
	            "type": "Independent"
	        },
	        "annotations": {
	            "describe": "just sshd servcie"
	        }
	    },
	    "spec": {
	        "volumes": [
	            {
	                "name": "default-token-qn3t7",
	                "secret": {
	                    "secretName": "default-token-qn3t7"
	                }
	            }
	        ],
	        "containers": [
	            {
	                "name": "sshproxy",
	                "image": "registry.local:5000/sshproxy:1.0",
	                "env": [
	                    {
	                        "name": "ROOTPASS",
	                        "value": "123456"
	                    }
	                ],
	                "resources": {
	                    "limits": {
	                        "cpu": "3",
	                        "memory": "128Mi"
	                    },
	                    "requests": {
	                        "cpu": "1",
	                        "memory": "32Mi"
	                    }
	                },
	                "volumeMounts": [
	                    {
	                        "name": "default-token-qn3t7",
	                        "readOnly": true,
	                        "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount"
	                    }
	                ],
	                "livenessProbe": {
	                    "tcpSocket": {
	                        "port": 22
	                    },
	                    "initialDelaySeconds": 5,
	                    "timeoutSeconds": 5
	                },
	                "terminationMessagePath": "/dev/termination-log",
	                "imagePullPolicy": "Always",
	                "securityContext": {
	                    "privileged": false
	                }
	            }
	        ],
	        "restartPolicy": "Never",
	        "terminationGracePeriodSeconds": 30,
	        "dnsPolicy": "Default",
	        "serviceAccountName": "default",
	        "serviceAccount": "default",
	        "nodeName": "kubelet.local"
	    },
	    "status": {
	        "phase": "Running",
	        "conditions": [
	            {
	                "type": "Ready",
	                "status": "True",
	                "lastProbeTime": null,
	                "lastTransitionTime": null
	            }
	        ],
	        "hostIP": "192.168.40.99",
	        "podIP": "172.16.222.1",
	        "startTime": "2016-03-02T09:50:25Z",
	        "containerStatuses": [
	            {
	                "name": "sshproxy",
	                "state": {
	                    "running": {
	                        "startedAt": "2016-03-02T09:50:36Z"
	                    }
	                },
	                "lastState": {},
	                "ready": true,
	                "restartCount": 0,
	                "image": "registry.local:5000/sshproxy:1.0",
	                "imageID": "docker://sha256:b90ac41616bf161bfc37afdd73a3f29ea441356bb921191d437839edf3a7be99",
	                "containerID": "docker://bc7cdf7be0edf75878b0093817d24854e56db9303774246e1bb23337b35eb256"
	            }
	        ]
	    }
	}

从上面的输出可以看到pod的IP是172.16.222.1，位于节点192.168.40.99上。尝试登陆:

	$ssh root@172.16.222.1
	root@172.16.222.1's password:
	Last login: Wed Mar  2 10:07:00 from 172.16.222.101
	[root@sshproxy ~]# pwd
	/root
	[root@sshproxy ~]# ls
	anaconda-ks.cfg  entrypoint.sh  sshd_config  sshd_log

## 通过kubectl在POD中执行命令




## 停止Pod

kubernetes里没有暂停一个Pod的概念，停止一个Pod，就是从kubernetes中删除这个pod。

	$../kubectl.sh stop  pods sshproxy --namespace=first-namespace
	 pod "sshproxy" deleted

>因此需要考虑将用户的Pod文件保存在kubernetes外部，避免用户重复的配置pod。其它的资源也是类似的。

## 文献
