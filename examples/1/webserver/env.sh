#!/bin/bash

#Get ipv4 address
func_ipv4_addr(){
	local ips=`ip addr |grep inet|grep -v inet6| awk '{print $2}'|sed "s/\/.*//"`
	echo $ips
}

echo "<pre>"
echo "Hostname:                        ${HOSTNAME}<br>"
echo "LocalIP:                         `func_ipv4_addr`<br>"
echo "<br>"

echo "REDIS_MASTER_PORT:               ${REDIS_MASTER_PORT}<br>"
echo "REDIS_MASTER_SERVICE_HOST:       ${REDIS_MASTER_SERVICE_HOST}<br>"
echo "REDIS_MASTER_SERVICE_PORT:       ${REDIS_MASTER_SERVICE_PORT}<br>"
echo "<br>"

echo "REDIS_SLAVE_PORT:               ${REDIS_SLAVE_PORT}<br>"
echo "REDIS_SLAVE_SERVICE_HOST:       ${REDIS_SLAVE_SERVICE_HOST}<br>"
echo "REDIS_SLAVE_SERVICE_PORT:       ${REDIS_SLAVE_SERVICE_PORT}<br>"
echo "<br>"

echo "WEBSERVER_PORT:                  ${WEBSERVER_PORT}<br>"
echo "WEBSERVER_SERVICE_HOST:          ${WEBSERVER_SERVICE_HOST}<br>"
echo "WEBSERVER_SERVICE_PORT:          ${WEBSERVER_SERVICE_PORT}<br>"
echo "<br>"
echo "</pre>"

echo "<pre>"
echo "All Env:<br>"
echo "`env|sed -e "s/$/<br>/"`"
echo "</pre>"

