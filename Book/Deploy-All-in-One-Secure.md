---
layout: default
title: Deploy-All-in-One-Secure

---

# Deploy-All-in-One-Secure
创建时间: 2016/02/02 10:38:44  修改时间: 2016/02/02 11:45:47 作者:lijiao

----

## 摘要

## 规划

假设All-in-One的机器的IP为192.168.40.99, 配置hosts如下:

	192.168.40.99 apiserver.local
	192.168.40.99 etcd.local
	192.168.40.99 kubelet.local

## 制作证书

这里只需要按照如下步骤将gen.sh脚本成功运行即可，证书的汇集在Deploy中操作。

制作Apiserver证书, Apiserver使用此证书提供https服务。

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

制作用户证书, kube-controller-manager、kube-scheduler、kubelet使用这里的证书向Apiserver进行认证。

	过程与Apiserver的证书制作过程相似, 在AuthnAuthz/authn/users创建与用户同名的目录, 然后执行gen.sh。

制作kubelets证书, kubelet节点使用这里的证书提供https服务。

	过程与Apiserver的证书制作过程相似, 在AuthnAuthz/kubeletes目录中创建与kubelet节点host同名的目录, 然后执行gen.sh。

制作ServiceAccount证书, kube-controller-manager和apiserver用这里的证书对Service的Token进行认证。

	直接到AuthnAuthz/serviceAccount目录中，执行gen.sh即可

## 编译程序

到Compile目录中执行compile.all.sh。与上一步类似，这里只需要确保脚本成功执行即可，程序文件的汇集在Deploy中操作。

## 部署

在Deploy/apiserver.local.secure的子目录中依次执行prepare.sh。

prepare.sh会自动去获需要的证书和程序。

## 启动

在Deploy/apiserver.local.secure的子目录依次执行以组件命名的脚本。

按照如下顺序启动组件:

	etcd --> flannel --> kube-apiserver --> kube-controller-manager 
	                                        kube-scheduler
	                                        kubelete
	                                        kube-proxy

启动方式以etcd为例:

	$cd  Deploy/apiserver.local.secure/1_etcd
	$./etcd.sh start     

>flannel在启动之前，需要先执行./net_init_config.sh, 在etcd中写入配置。

>一些组件需要有较高的运行的权限, 例如kubelet。

## 文献
