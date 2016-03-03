---
layout: default
title: Events

---

# Events
创建时间: 2016/02/25 17:03:20  修改时间: 2016/03/03 18:43:58 作者:lijiao

----

## 摘要

Kubernetes系统内部的日志是以事件(events)的形式记录的。

## 查看事件

	$../kubectl.sh get ev
	FIRSTSEEN   LASTSEEN   COUNT NAME            KIND  SUBOBJECT   REASON                  SOURCE                    MESSAGE
	41m         41m        1     kubelet.local   Node              RegisteredNode          {controllermanager }      Node kubelet.local event: Registered Node kubelet.local in NodeController
	41m         41m        1     kubelet.local   Node              Starting                {kubelet kubelet.local}   Starting kubelet.
	41m         41m        1     kubelet.local   Node              NodeHasSufficientDisk   {kubelet kubelet.local}   Node kubelet.local status is now: NodeHasSufficientDisk
	41m         41m        1     kubelet.local   Node              NodeReady               {kubelet kubelet.local}   Node kubelet.local status is now: NodeReady
	41m         41m        1     kubelet.local   Node              Rebooted                {kubelet kubelet.local}   Node kubelet.local has been rebooted, boot id: 9e227968-be7a-44b8-9af4-13c4b26652db

查看指定namespace的事件:

	$../kubectl.sh get events --namespace=first-namespace
	FIRSTSEEN   LASTSEEN   COUNT     NAME       KIND      SUBOBJECT   REASON             SOURCE         MESSAGE
	12m         7m         21        sshproxy   Pod                   FailedScheduling   {scheduler }   Failed for reason MatchNodeSelector and possibly others
	7m          7m         1         sshproxy   Pod                   Scheduled          {scheduler }   Successfully assigned sshproxy to kubelet.local

## 文献
