#!/bin/bash
CENTER_SERVER="http://192.168.202.240/HoneyComb/lastest/"

VERSION_DIR=/export/Version

if [ ! -d  ${VERSION_DIR} ];then
	mkdir -p ${VERSION_DIR}
fi

EXPORT_VERSION_URL="${CENTER_SERVER}/export_version"
EXPORT_VERSION_FILE="${VERSION_DIR}/export_version"
wget -O $EXPORT_VERSION_FILE  $EXPORT_VERSION_URL 
if [[ $? != 0 ]];then
	echo "Error"
	exit 1
fi

EXPORT_URL="${CENTER_SERVER}/export.tar.gz"
EXPORT_FILE="${VERSION_DIR}/export.tar.gz"
wget -O $EXPORT_FILE $EXPORT_URL
if [[ $? != 0 ]];then
	echo "Error"
	exit 1
fi

BASE_VERSION_URL="${CENTER_SERVER}/base_version"
BASE_VERSION_FILE="${VERSION_DIR}/base_version"
wget -O $BASE_VERSION_FILE $BASE_VERSION_URL
if [[ $? != 0 ]];then
	echo "Error"
	exit 1
fi

cur=`pwd`
cd ${VERSION_DIR}
tar -xvf $EXPORT_FILE
/bin/cp  -rf  OutPut/export/*   /export/
cd $cur

echo  -n -e "\e[32m"
	echo "Now, If you want auto upgrade, add the contab job into /etc/crontab"
echo  -n -e "\e[0m"

echo  -n -e "\e[31m"
	echo "It will auto start when upgrade is finished"
echo  -n -e "\e[0m"

echo  -n -e "\e[33m"
	echo ""
	echo "/etc/crontab:"
	echo "   */5 * * * * root cd /export/Shell; bash ./update.sh"
	echo ""
echo  -n -e "\e[0m"

echo  -n -e "\e[32m"
	echo "Start:"
	echo "   cd /export/Shell; ./run.sh"
echo  -n -e "\e[0m"
