---
layout: default
title: Secure

---

# Secure
创建时间: 2016/02/02 10:38:44  修改时间: 2016/02/03 17:59:44 作者:lijiao

----

## 摘要

## 规划

假设All-in-One的机器的IP为192.168.40.99, 配置hosts如下:

	192.168.40.99 apiserver.local
	192.168.40.99 etcd.local
	192.168.40.99 kubelet.local

## 证书

只需要在AuthnAuthz目录中执行对应的gen.sh脚本即可，证书的汇集将在Deploy中完成。

规划如下:

	1. 用于签署Apiserver的公钥的自签署CA， 位于AuthnAuthz/apiserver/ca；
	2. Apiserver用于https的服务的密钥对，位于AuthnAuthz/apiserver/apiservers/{域名 or IP}；
		apiserver.local
	3. 用于签署用户的用户身份凭证的公钥的CA，位于AuthnAuthz/authn/ca；
	4. 用户用作身份凭证的密钥对，位于AuthnAuthz/users/{用户名}；
		admin-cluster
		admin-project
		heapster
		kube-controller-manager
		kube-kubelet
		kube-proxy
		kube-scheduler
		kube2sky
		user-alice
		user-bob
		user-guest
	5. 用与签署kubelet的公钥的密钥对，位于AuthnAuthz/kubeletes/ca；
	6. kubelet用作身份凭证的密钥对，位于AuthnAuthz/kubeletes/kubeletes/{Hostname or IP}；
		kubelet.local
	7. 用于签署Service Token的CA，位于AuthnAuthz/serviceAccount/ca；

示例，apiserver.local的证书制作过程：

	$cd    AuthnAuthz/apiserver/
	$mkdir apiservers/apiserver.local
	$./gen.sh
	 Generat All?[Y|N]:  N
	 req.noprompt
	 req.prompt
	 Choose the req template:  req.noprompt       <--选择证书模版
	 127.0.0.1
	 192.168.183.59
	 192.168.40.99
	 apiserver.local
	 Choose the apiserver:  apiserver.local       <--为apiserver.local制作证书
	 Generating a 2048 bit RSA private key
	 ...............................+++
	 .............................+++
	 writing new private key to './Cert/key.pem'
	 -----
	 Signature ok
	 subject=/C=CN/ST=BeiJing/L=BeiJing/O=k8s/OU=k8s/CN=apiserver.local
	 Getting CA Private Key
	 It's OK.
	 locate at: ./apiservers/apiserver.local/Cert 

## 文献

1. http://xxx  "Name"
