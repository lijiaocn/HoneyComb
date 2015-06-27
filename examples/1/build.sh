#!/bin/bash
#docker build -t base-os ./base-os/


#docker build -t 192.168.202.240:5000/lijiao/example-1-redis:2.8.19 ./redis/
#docker push 192.168.202.240:5000/lijiao/example-1-redis:2.8.19

docker build -t 192.168.202.240:5000/lijiao/example-1-redis-master:2.8.19 ./redis-master
docker push 192.168.202.240:5000/lijiao/example-1-redis-master:2.8.19 

docker build -t 192.168.202.240:5000/lijiao/example-1-redis-slave:2.8.19 ./redis-slave
docker push 192.168.202.240:5000/lijiao/example-1-redis-slave:2.8.19 

#docker build -t  192.168.202.240:5000/lijiao/example-1-webserver:0.1  ./webserver
#docker push 192.168.202.240:5000/lijiao/example-1-webserver:0.1
