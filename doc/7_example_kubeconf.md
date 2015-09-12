---
layout: default
title: 7_example_kubeconf

---

# 7_example_kubeconf
创建时间: 2015/09/10 15:36:40  修改时间: 2015/09/10 16:22:22 作者:lijiao

----

## 摘要

为了方便的切换到另一个k8s集群, 或者切换用户身份, k8s提供kubeconf功能。

kubectl、kubelet、kube-controller-manager和kube-scheduler在访问kube-apiserver的时候如果指定了kubeconf, 就会自动使用kubeconf指定的身份访问对应的集群。

[kubeconf](https://github.com/kubernetes/kubernetes/blob/release-1.0/docs/user-guide/kubeconfig-file.md)

## kubeconf格式

kubeconf是yaml格式, 对应的Object是: pkg/client/clientcmd/api/types.go中的

	// Config holds the information needed to build connect to remote kubernetes clusters as a given user
	type Config struct {
	    // Legacy field from pkg/api/types.go TypeMeta.
	    // TODO(jlowdermilk): remove this after eliminating downstream dependencies.
	    Kind string `json:"kind,omitempty"`
	    // Version of the schema for this config object.
	    APIVersion string `json:"apiVersion,omitempty"`
	    // Preferences holds general information to be use for cli interactions
	    Preferences Preferences `json:"preferences"`
	    // Clusters is a map of referencable names to cluster configs
	    Clusters map[string]Cluster `json:"clusters"`
	    // AuthInfos is a map of referencable names to user configs
	    AuthInfos map[string]AuthInfo `json:"users"`
	    // Contexts is a map of referencable names to context configs
	    Contexts map[string]Context `json:"contexts"`
	    // CurrentContext is the name of the context that you would like to use by default
	    CurrentContext string `json:"current-context"`
	    // Extensions holds additional information. This is useful for extenders so that reads and writes don't clobber unknown fields
	    Extensions map[string]runtime.EmbeddedObject `json:"extensions,omitempty"`
	}

## 示例

allinone, apiserver地址为127.0.0.1:8080

kubeconf for kubelet:







## 文献
1. http://xxx  "Name"


