---
layout: default
title: 7_example_kubeconf

---

# 7_example_kubeconf
创建时间: 2015/09/10 15:36:40  修改时间: 2015/09/28 13:44:58 作者:lijiao

----

## 摘要

为了方便的切换到另一个k8s集群, 或者切换用户身份, k8s提供kubeconf功能。

kubectl、kubelet、kube-controller-manager和kube-scheduler在访问kube-apiserver的时候如果指定了kubeconf, 就会自动使用kubeconf指定的身份访问对应的集群。

[kubeconf](https://github.com/kubernetes/kubernetes/blob/release-1.0/docs/user-guide/kubeconfig-file.md)

https://github.com/kubernetes/kubernetes/blob/release-1.0/docs/user-guide/kubectl/kubectl_config.md
## kubeconf格式

kubeconf是yaml格式, 对应的Object是: pkg/client/clientcmd/api/v1/types.go中的

	type Config struct {
	   // Legacy field from pkg/api/types.go TypeMeta.
	   // TODO(jlowdermilk): remove this after eliminating downstream dependencies.
	   Kind string `json:"kind,omitempty"`
	   // Version of the schema for this config object.
	   APIVersion string `json:"apiVersion,omitempty"`
	   // Preferences holds general information to be use for cli interactions
	   Preferences Preferences `json:"preferences"`
	   // Clusters is a map of referencable names to cluster configs
	   Clusters []NamedCluster `json:"clusters"`
	   // AuthInfos is a map of referencable names to user configs
	   AuthInfos []NamedAuthInfo `json:"users"`
	   // Contexts is a map of referencable names to context configs
	   Contexts []NamedContext `json:"contexts"`
	   // CurrentContext is the name of the context that you would like to use by default
	   CurrentContext string `json:"current-context"`
	   // Extensions holds additional information. This is useful for extenders so that reads and writes don't clobber unknown fields
	   Extensions []NamedExtension `json:"extensions,omitempty"`
	}

## 示例

	kind: Config
	apiVersion: v1
	preferences:
	  colors: true
	clusters:
	- name: allinone
	  cluster:
		server: https://localhost:6443
		api-version: v1
		insecure-skip-tls-verify: false
		certificate-authority:  ./cert-authn/ca.pem
	users:
	- name: kube-controller-manager
	  user:
		client-certificate: ./cert-authn/cert.pem
		client-key: ./cert-authn/key.pem
	contexts:
	- name: allinone-kube-controller-manager
	  context:
		cluster: allinone
		user: kube-controller-manager
		namespace: default

	current-context: allinone-kube-controller-manager

## 文献


