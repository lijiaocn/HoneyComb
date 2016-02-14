---
layout: default
title: Authz

---

# Authz
创建时间: 2016/02/02 11:46:15  修改时间: 2016/02/14 14:04:41 作者:lijiao

----

## 摘要

## 授权策略

在AuthnAuthz/authz中编辑policy.json文件。

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

启动apiserver的时候，将授权模式设置为ABAC，同时指定授权策略文件（即上面的policy.json）。

	Ordered list of plug-ins to do authorization on secure port. Comma-delimited list of: AlwaysAllow,AlwaysDeny,ABAC
	--authorization-mode=ABAC

	File with authorization policy in csv format, used with --authorization-mode=ABAC, on the secure port.
	--authorization-policy-file=policy.json 

## 文献
