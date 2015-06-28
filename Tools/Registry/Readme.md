---
layout: default
title: Readme

---

# Readme
创建时间: 2015/06/17 14:36:18  修改时间: 2015/06/27 17:45:38 作者:lijiao

----

## 摘要

Registry用来部署一个Docker Registry。

这里只给出一种可行的方式。

## 安装

目标机器: 192.168.202.240

目标机上需要已经安装有docker，并启动:

	service docker start

将./registry.tar.gz复制到目标机:

	scp registry.tar.gz  root@192.168.202.240:/root/

在目标机上导入registry.tar.gz

	dpcker load -i registry.tar.gz

导入结束后，可以看到新增加的registry

	[root@localhost ~]# docker images 
	REPOSITORY          TAG                 IMAGE ID            CREATED                  VIRTUAL SIZE
	registry            latest              204704ce3137        Less than a second ago   413.8 MB

启动registry:

	docker run --name "HoneyComb-Registry" -e STORAGE_PATH=/export/Data/registry.dat -p 5000:5000 -v /export/Data:/export/Data registry  &

## 文献
1. http://xxx  "Name"


