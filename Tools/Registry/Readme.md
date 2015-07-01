---
layout: default
title: Readme

---

# Readme
创建时间: 2015/06/17 14:36:18  修改时间: 2015/07/01 13:49:13 作者:lijiao

----

## 摘要

Registry用来部署一个Docker Registry。

这里只给出一种可行的方式。

## 安装

使用docker pull直接拉去registry镜像:

	$ docker search registry
	NAME                                    DESCRIPTION                                     STARS     OFFICIAL   AUTOMATED
	registry                                Containerized docker registry                   306       [OK]       
	atcol/docker-registry-ui                A web UI for easy private/local Docker Reg...   53                   [OK]
	konradkleine/docker-registry-frontend   Browse and modify your Docker registry in ...   37                   [OK]
	samalba/docker-registry                                                                 35                   [OK]

	$ docker pull registry

可以看到新增加的registry

	[root@localhost ~]# docker images 
	REPOSITORY          TAG                 IMAGE ID            CREATED                  VIRTUAL SIZE
	registry            latest              204704ce3137        Less than a second ago   413.8 MB

启动registry:

	docker run --name "HoneyComb-Registry" -e STORAGE_PATH=/export/Data/registry.dat -p 5000:5000 -v /export/Data:/export/Data registry  &

## 文献
1. http://xxx  "Name"


