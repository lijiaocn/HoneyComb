---
layout: default
title: Secure

---

# Secure
创建时间: 2016/02/02 10:38:44  修改时间: 2016/02/14 10:54:19 作者:lijiao

----

## 摘要

## 规划

假设All-in-One的机器的IP为192.168.40.99, 配置hosts如下:

	192.168.40.99 apiserver.local
	192.168.40.99 etcd.local
	192.168.40.99 kubelet.local

## 证书

>用户认证使用的证书单独在“认证”一章中阐述。

只需要在AuthnAuthz目录中执行对应的gen.sh脚本即可。

规划如下:

	1. 用于签署Apiserver的公钥的自签署CA， 位于AuthnAuthz/apiserver/ca；
	2. Apiserver用于https的服务的密钥对，位于AuthnAuthz/apiserver/apiservers/{域名 or IP}；
		apiserver.local
	3. 用与签署kubelet的公钥的密钥对，位于AuthnAuthz/kubeletes/ca；
	4. kubelet用作身份凭证的密钥对，位于AuthnAuthz/kubeletes/kubeletes/{Hostname or IP}；
		kubelet.local
	5. 用于签署Service Token的CA，位于AuthnAuthz/serviceAccount/ca；

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
