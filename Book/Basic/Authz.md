---
layout: default
title: Authz

---

# Authz
创建时间: 2016/02/02 11:46:15  修改时间: 2016/03/03 18:29:39 作者:lijiao

----

## 摘要

## 授权策略

在AuthnAuthz/authz中编辑policy.json文件。

	{"user":"admin-super"}
	{"user":"admin-cluster", "resource": "nodes"}
	{"user":"admin-project", "resource": "services"}
	{"user":"kube-scheduler", "resource": "events"}
	{"user":"kube-scheduler", "resource": "endpoints"}
	{"user":"kube-scheduler", "resource": "pods"}
	{"user":"kube-scheduler", "resource": "bindings"}
	{"user":"kube-scheduler", "resource": "services"}
	{"user":"kube-scheduler", "resource": "nodes"}
	{"user":"kube-kubelet", "readonly": true, "resource": "secrets"}
	{"user":"kube-kubelet", "resource": "nodes"}
	{"user":"kube-kubelet", "resource": "pods"}
	{"user":"kube-kubelet", "readonly": true, "resource": "services"}
	{"user":"kube-kubelet", "readonly": true, "resource": "endpoints"}
	{"user":"kube-kubelet", "resource": "events"}
	{"user":"kube-proxy", "readonly":true, "resource":"services"}
	{"user":"kube-proxy", "readonly":true, "resource":"endpoints"}
	{"user":"kube-controller-manager"}
	{"user":"user-alice", "namespace": "user_alice"}
	{"user":"user-bob",   "namespace": "user_bob"}
	{"user":"user-guest", "readonly": true, "namespace":"user_guest"}
	{"user":"system:serviceaccount:kube-system:default"}
	{"user":"kube2sky", "readonly":true}

## 说明

启动apiserver的时候，会将授权模式设置为ABAC，同时指定授权策略文件（即上面的policy.json）（在apiserver的配置文件设置）。

对应的如下的命令行参数：

	Ordered list of plug-ins to do authorization on secure port. Comma-delimited list of: AlwaysAllow,AlwaysDeny,ABAC
	--authorization-mode=ABAC

	File with authorization policy in csv format, used with --authorization-mode=ABAC, on the secure port.
	--authorization-policy-file=policy.json 

## 文献
