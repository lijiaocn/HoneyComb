#!/bin/bash

###############################################################################
#                                                                             #
#                                Time Operation                               #
#                                                                             #
###############################################################################
func_since_1970(){
    echo `date +"%s"`
}
func_cur_date(){
    echo `date +"%Y%m%d"`
}
func_yesterday_date(){
    echo `date -d yesterday +"%Y%m%d"`
}
func_before_yesterday_date(){
    echo `date -d "-2 day" +"%Y%m%d"`
}
func_cur_time(){
    echo `date +"%Y-%m-%d %H:%M:%S"`
}
func_yesterday_time(){
    echo `date -d yesterday +"%Y-%m-%d %H:%M:%S"`
}
###############################################################################
#                                                                             #
#                                Base Convert Operation                       #
#                                                                             #
###############################################################################
#convert 16base into 10base
#
func_16to10(){
	echo "ibase=16;obase=A; $1"|bc
}

###############################################################################
#                                                                             #
#                                Info  Operation                              #
#                                                                             #
###############################################################################
#Get the net interfaces's name
func_nic_names(){
	local names=`ip addr |grep \<.*\>|awk '{print $2}'|sed -e "s/://"`
	echo $names
}

###############################################################################
#                                                                             #
#                                Error Operation                              #
#                                                                             #
###############################################################################
#$1: message
func_fatal(){
	echo  -n -e "\e[31m"
	echo "Fatal Error: $1"
	echo  -n -e "\e[0m"
	exit
}

###############################################################################
#                                                                             #
#                                Color Operation                              #
#                                                                             #
###############################################################################

#Input is the command.
#The command's execute output will use red color
func_red_cmd(){
	echo  -n -e "\e[31m"
	$*
	echo  -n -e "\e[0m"
}

#Input is the command.
#The command's execute output will use yellow color
func_yellow_cmd(){
	echo  -n -e "\e[33m"
	$*
	echo  -n -e "\e[0m"
}

#Input is the command
#If command is error, display the error
func_error_cmd(){
	$*
	local ret=$?
	if [ ! $ret -eq 0 ];then
		echo  -n -e "\e[41;37m"
		echo "Error: [$ret] $*"
		echo  -n -e "\e[0m"
		exit 1
	fi
	return 0
}

#Input is a string.
#The string  will be displayed with green color
func_green_str(){
	echo  -n -e "\e[32m"
	echo  -e "$*"
	echo  -n -e "\e[0m"
}

func_yellow_str(){
	echo  -n -e "\e[33m"
	echo  -e "$*"
	echo  -n -e "\e[0m"
}

#Input is a string.
#The string  will be displayed with red color
func_red_str(){
	echo  -n -e "\e[31m"
	echo  -e "$*"
	echo  -n -e "\e[0m"
}

###############################################################################
#                                                                             #
#                       Systemd Service Operation                             #
#                                                                             #
###############################################################################

#Start a systemd style Service
func_start_sd_service(){
	systemctl start $1
	sleep 1
	local sta=`systemctl status ${1} |grep "Active: failed"`
	if [ -n "$sta" ];then
		func_red_str   "Start[Fail] $1"
		func_red_str   "            $sta"
		ret=1
	else
		local x=`systemctl status ${1} | grep "Active:"`
		func_green_str "Start[OK]   $1"
		func_green_str "            $x"
	fi
	return $ret
}

#Start a systemd style Service
func_stop_sd_service(){
	systemctl stop $1
	ret=$?
	local sta=`systemctl status ${1} |grep "Active:"`
	func_yellow_str "Stopping $1"
	func_yellow_str "         $sta"
}

###############################################################################
#                                                                             #
#                            Directory Operation                              #
#                                                                             #
###############################################################################

#Create Dirs: $1 $2 $3 ...
func_create_dirs(){
	for i in $*
	do
		if [ ! -d $i ];then
			mkdir -p $i
		fi
	done
}

#Force Copy: 
#$1: Destiation Directory
#$2,$3,$4,...: Source File or Directories
func_force_copy(){
	local dest=$1
	shift 1

	if [ ! -d $dest ];then
		func_red_str "Dest Dir doesn't exist: $dest"
		return 1
	fi
	
	for i in $*
	do
		if [ ! -e $i ];then
			func_red_str "Not Found: $i"
			return 1
		fi
	done

	for i in $*
	do
		cp -rf $i $dest/
	done
}

###############################################################################
#                                                                             #
#                                Git operation                                #
#                                                                             #
###############################################################################

#$1: respositry url
#$2：branch
#$3: tag
#$4: local directory
func_git_check_tag(){
	local url=$1
	local branch=$2
	local tag=$3
	local dir=$4

	if [ ! -e $dir ];then
		func_error_cmd git clone $url $dir
		if [ ! $?  -eq 0 ];then
			func_red_str "Something is wrong in cloning"
			return 1
		fi
	fi

	if [ ! -d $dir ];then
		func_red_str "The local respositry is not a directory"
		return 1
	fi

	local cur=`pwd`
	cd $dir
		func_error_cmd git checkout master
		func_error_cmd git pull 
		func_error_cmd git checkout $branch
		func_error_cmd git checkout $tag
		if [ ! $? -eq 0 ];then
			return 1
		fi
	cd $cur
}

###############################################################################
#                                                                             #
#                                Daemon Command                               #
#                                                                             #
###############################################################################

#$1: pidfile
#$2: log file
#$3: commands
func_daemon_cmd(){
	local sec=`func_since_1970`
	local pidfile=$1
	#local stdout="$2.$sec.stdout"
	#local stderr="$2.$sec.stderr"
	local stdout="$2.stdout"
	local stderr="$2.stderr"
	shift 2
	
	echo "=======  Start at"`func_cur_date`"======================" >$stdout
	echo "=======  Start at"`func_cur_date`"======================" >$stderr
	$* 1>>$stdout 2>>$stderr &
	local pid=$!
	echo $pid >$pidfile
}

#$1: pid
func_check_pid(){
	ps -p $1 1>/dev/null 2>&1
	if [ $? -eq 0 ];then
		return 0
	fi
	return 1
}

#$1: pid
#$2: pid desc
func_no_pid(){
	func_check_pid  $1
	if [ ! $? -eq 0 ];then
		func_red_str "Pid($1:$2) doesn't exist"
		return 1
	fi
	return 0
}

#$1: pid file
#$2: log file
#$3: executuable binary file name
#$4: command
func_start_cmd(){
	local pidf=$1
	local logf=$2
	local name=$3
	shift 3
	local cmd=$*

	if [ -e $pidf ];then
		func_red_str "The PID file has already existed, please check: $pidf"
		func_yellow_str "It may be running or hasn't delete the PID file when it was stopped last time"
		exit 1
	fi
	func_daemon_cmd $pidf $logf $cmd
	sleep 2
	func_no_pid `cat $pidf` "[Fail]${name} is not running!"
	if [ $? -eq 0 ];then
		return 0
	else
		echo "cmd:"
		echo "$cmd"
		rm $pidf
		return 1
	fi
}

#$1: pid file
func_stop_cmd(){
	local pidf=$1

	if [ ! -e $pidf ];then
		func_red_str "The PID file doesn't exist': $pidf"
		func_yellow_str "It may be not running"
		exit 1
	fi

	local pid=`cat $pidf`
	if [ "$pid" == "1" ];then
		func_red_str "You are not allowed to stop PID 1 !"
		exit 1
	else
		kill -9 $pid
		rm -rf $pidf
	fi
	return 0
}

#$1: Target executable  file
#$2: Log path
#$3: An config Array's name, the Array must be global. Becareful, Just give Name, not value(no $)
#$4: Other parametes from the command line, [start|stop]
func_service_template_1(){
	local TARGET=$1
	local Logs=$2
	eval config_2334200776=\${$3[@]}
	local cmdline=$4
	CMD="${TARGET} ${config_2334200776[@]}"
	NAME=`basename ${TARGET}`
	PID_FILE="${Logs}/${NAME}.pid"
	LOG_FILE="${Logs}/${NAME}"
	OPERATE="${Logs}/${NAME}.operate"

	start(){
		func_start_cmd $PID_FILE $LOG_FILE $NAME $CMD
		if [ $? == 0 ];then
			func_green_str "$TARGET is running"
		fi
		echo -e "`func_cur_time`: [start] $CMD" >>$OPERATE
	}

	stop(){
		func_stop_cmd $PID_FILE
		if [ $? == 0 ];then
			func_red_str "$TARGET is terminated"
		fi
		echo -e "`func_cur_time`: [stop]" >>$OPERATE
	}

	case $cmdline in
		(start)
			start;;
		(stop)
			stop;;
		(*)
			echo "usage: $0 [stop|start]"
	esac
}

###############################################################################
#                                                                             #
#                                Arrary Operation                             #
#                                                                             #
###############################################################################

#$1: sep string
#$2: prefix
#$3: Array's name, the Array must be global. Becareful, Just give Name, not value(no $)
#$4: postfix
func_join_array(){
	local sep=$1
	local prefix=$2
	local postfix=$4
	eval array_doimgaeg3234553=(\${$3[@]})
	local len=${#array_doimgaeg3234553[@]}

	if [ $len -eq 1 ];then
		echo ${prefix}${array_doimgaeg3234553[@]}${postfix}
		return 0
	fi

	local i=0
	local str=${prefix}${array_doimgaeg3234553[$i]}${postfix}
	i=$(($i+1))

	while [ $i -lt $len ]
	do
		str=${str}${sep}${prefix}${array_doimgaeg3234553[$i]}${postfix}
		i=$(($i+1))
	done
	echo $str
	return 0
}

#if value is in array, return 0, else return 1
#$1: value
#$2: Array's name, the Array must be global. Becareful, Just give Name, not value(no $)
func_in_array(){
	eval array_adfadfadfgli3323455=(\${$2[@]})
	for i in ${array_adfadfadfgli3323455[@]}
	do
		if [ $i == $1 ];then
			return 0
		fi
	done
	return 1
}

###############################################################################
#                                                                             #
#                                 System info                                 #
#                                                                             #
###############################################################################
#Get ipv4 address
func_ipv4_addr(){
	local ips=`ip addr |grep inet|grep -v inet6| awk '{print $2}'|sed "s/\/.*//"`
	echo $ips
}


###############################################################################
#                                                                             #
#                                 Update Operation                            #
#                                                                             #
###############################################################################

#return 0: the file is updated  1: nothing is changed 2:remote is wrong.
#must checksum by sha1sum
#$1: local version file
#$2: remote version url
#$3: local file path
#$4: remote file url
func_update_file(){
	if [ ! -e $1 ];then
		func_red_str "Can't found Local Version"
		exit 1
	fi

	local lver=`cat $1`
	if [ "$lver" == "" ];then
		func_red_str "Local Version is NULL!"
		exit 1
	fi

	local rver=`curl $2 2>/dev/null |grep -v \<`
	if [ "$rver" == "" ];then
		func_red_str "Can't get Remote Version"
		exit 1
	fi

	if [ "$lver" == "$rver" ];then
		func_green_str "Local Version matches the Remote Version."
		return 1
	fi

	local lfile=$3
	curl -o $lfile  $4 2>/dev/null

	local lsha1=`sha1sum $lfile|awk '{print $1}'`
	local rsha1=`echo $rver|awk '{print $1}'`
	
	if [ "$lsha1" == "$rsha1" ];then
		func_green_str "The Remote Version file lays: $lfile"
		return 0
	else
		func_red_str "The Remote File dosen't match the Remote Version: $lfile"
		return 2
	fi
}

#$1: local file path
#$2: remote file url
func_replace_lfile(){
	curl -o $1 $2 2>/dev/null
}

#get a file and check the sha1 code
#$1 local file
#$2 file url
#$3 sha1 code url
func_curl_file_sha1(){
	local rsha1=`curl $3 2>/dev/null|grep -v \<|awk '{print $1}'`
	if [ "$rsha1" == "" ];then
		func_red_str "Can't the file sha1 code!"
		return 1
	fi
	curl -o $1 $2 
	local lsha1=`sha1sum $1|awk '{print $1}'`

	if [ "$lsha1" == "$rsha1" ];then
		func_green_str "The File lays: $lfile"
		return 0
	else
		func_red_str "The File dosen't match the sha1 code: $1"
		return 2
	fi
}

###############################################################################
#                                                                             #
#                         Interactive Operation                               #
#                                                                             #
###############################################################################
#$1: password
#$2...: cmds
func_cmd_need_password(){
	local password=$1
	shift 1
	expect -c "
		spawn $*
		expect {
			\"*password:\" {set timeout 300; send \"${password}\r\";}
			\"*yes/no\" {send \"yes\r\"; exp_continue;}
		}
	expect eof"
}

#$1: VARNAME
#$2: prompt
func_secret_input(){
	echo -n "$2"
	stty -echo
	read $1
	stty echo
	echo ""
}

