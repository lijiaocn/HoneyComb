---
layout: default
title: Cli

---

# Cli
创建时间: 2016/02/14 14:32:20  修改时间: 2016/02/22 17:53:38 作者:lijiao

----

## 摘要

Deploy/apiserver.local.secure中的cmd-etcdctl和cmd-kubectl是两个命令行工具。

## etcd

	./etcd ls

## kubectl

cmd-kubectl中存在两个子目录路: secure和unsecure。在不同的子目录下，会使用不同的身份向kubernetes发起请求。

例如，使用unsecure运行：

	cd ./unsecure
	./kubectl.sh   get nodes   

使用admin-cluster的身份运行：

	cd ./secure/admin-cluster
	../kubectl.sh get nodes

注意有可能遇到这种情况:

	error: couldn't read version from server: the server does not allow access to the requested resource
	
	#../kubectl.sh --v=10 get nodes
	I0214 06:53:12.065085    2940 debugging.go:102] curl -k -v -XGET  -H "User-Agent: kubectl/v1.1.4 (linux/amd64) kubernetes/a5949fe" https://apiserver.local/api
	I0214 06:53:12.093217    2940 debugging.go:121] GET https://apiserver.local/api 403 Forbidden in 27 milliseconds
	I0214 06:53:12.093258    2940 debugging.go:127] Response Headers:
	I0214 06:53:12.093271    2940 debugging.go:130]     Date: Sun, 14 Feb 2016 06:53:12 GMT
	I0214 06:53:12.093294    2940 debugging.go:130]     Content-Length: 17
	I0214 06:53:12.093307    2940 debugging.go:130]     Content-Type: text/plain; charset=utf-8
	I0214 06:53:12.093936    2940 request.go:746] Response Body: Forbidden: "/api"
	I0214 06:53:12.093988    2940 request.go:803] Response Body: Forbidden: "/api"
	F0214 06:53:12.094935    2940 helpers.go:96] error: couldn't read version from server: the server does not allow access to the requested resource

可以看到是对/api没有访问权限的缘故，Kubectl会到该地址获取api版本。

这里存在一个授权的问题，1.2.0版本的代码中已经在对授权做更细粒度的划分，增加了对非资源类型对api的权限控制。

另外可以使用curl直接访问api:

	#../curl.sh  nodes
	{
	    "apiVersion": "v1",
	        "items": [
	        {
	            "metadata": {
	                "creationTimestamp": "2016-02-14T06:48:17Z",
	                "labels": {
	                    "kubernetes.io/hostname": "kubelet.local"
	....（省略）....

## 文献
