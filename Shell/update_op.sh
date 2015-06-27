#!/bin/bash
. ./library.sh

CENTER_SERVER="http://192.168.202.240/HoneyComb/lastest/"
VERSION_DIR=/export/Version

EXPORT_VERSION_FILE="${VERSION_DIR}/export_version"
EXPORT_VERSION_URL="${CENTER_SERVER}/export_version"
EXPORT_FILE="${VERSION_DIR}/export.tar.gz"
EXPORT_URL="${CENTER_SERVER}/export.tar.gz"
func_update_file $EXPORT_VERSION_FILE $EXPORT_VERSION_URL $EXPORT_FILE $EXPORT_URL

if [ $? -eq 0 ];then
	cur=`pwd`
	cd ${VERSION_DIR}
		tar -xvf $EXPORT_FILE
	cd $cur

	cd /export/Shell/
		bash ./stop.sh    
	cd $cur

	/bin/cp -rf ${VERSION_DIR}/OutPut/export/*  /export/

	cd /export/Shell/
		bash ./run.sh
	cd $cur
	func_replace_lfile $EXPORT_VERSION_FILE $EXPORT_VERSION_URL
fi

BASE_VERSION_FILE="${VERSION_DIR}/base_version"
BASE_VERSION_URL="${CENTER_SERVER}/base_version"
BASE_FILE="${VERSION_DIR}/base.sh"
BASE_URL="${CENTER_SERVER}/base.sh"
func_update_file $BASE_VERSION_FILE $BASE_VERSION_URL $BASE_FILE $BASE_URL

if [ $? -eq 0 ];then
	cur=`pwd`

	cd /export/Shell/
		bash ./stop.sh    
	cd $cur

	cp $BASE_FILE /export/Shell/

	cd /export/Shell/
		bash ./run.sh
	cd $cur
	func_replace_lfile  $BASE_VERSION_FILE $BASE_VERSION_URL
fi
