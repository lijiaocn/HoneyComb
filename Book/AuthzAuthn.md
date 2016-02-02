---
layout: default
title: AuthzAuthn

---

# AuthzAuthn
创建时间: 2016/02/02 11:46:15  修改时间: 2016/02/02 16:58:53 作者:lijiao

----

## 摘要

## 制作用户证书

在AuthnAuthz/authn/users目录中创建以用户名命名的子目录, 然后在AuthnAuthz/authn/目录中执行gen.sh。

gen.sh会提示选择证书的模版和用户，制作结束后，会生成如下的文件：

	user-alice/
	├── Cert
	│   ├── ca.csr
	│   ├── cert.pem      <-－用户的证书
	│   └── key.pem       <-- 用户的密钥
	└── req.config

## 制作授权策略

在AuthnAuthz/authz中编辑policy.json文件，apiserver启动的时候。

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
