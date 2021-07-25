#!/bin/bash

cat << HERD
=======日常巡检=======
=       1.CPU        =
=       2.内存       =
=       3.硬盘       =
=       0.退出       =
======================
HERD

while :
do
	read -p "Please enter what you want to see:" num	# 输入想要查看的信息块
	
	case $num in
	    1)	
		CPU_ID=`grep "physical id" /proc/cpuinfo |sort |uniq |wc -l`	# /proc/cpuinfo CPU的相关配置信息
		CPU_CORES=`grep "cores" /proc/cpuinfo |sort |uniq |awk '{print $4}'`
		CPU_MODE=`grep "model name" /proc/cpuinfo |sort |uniq |awk -F: '{print $2}'`
		
		echo -e "\033[34m CPU 数量：$CPU_ID\033[0m"
		echo -e "\033[34m CPU 核心：$CPU_CORES\033[0m"
		echo -e "\033[34m CPU 型号：$CPU_MODE\033[0m"
		;;
	    2)
		MEM_TOTAL=`free -m |grep Mem |awk '{print $2}'`		# free 查看内存的命令
		MEM_FREE=`free -m |grep Mem |awk '{print $7}'`
		
		echo -e "\033[34m 内存总容量：${MEM_TOTAL}MB\033[0m"
		echo -e "\033[34m 剩余内存容量：${MEM_FREE}MB\033[0m"
		;;
	    3)
		DISK_SIZE=0	# 初始化磁盘大小为0
		SWAP_SIZE=`free |grep Swap |awk '{print $2}'` 	# 交换分区大小
		PARTITION_SIZE=(`df -T |sed 1d |egrep -v "tmpfs" |awk '{print $3}'`)	# 以元组形式显示硬盘大小
		for (( i=0; i<`echo ${#PARTITION_SIZE[*]}`; i++ ))	# 计算磁盘大小
		do
			DISK_SIZE=`expr $DISK_SIZE + ${PARTITION_SIZE[$i]}`
		done
		((DISK_SIZE=\($DISK_SIZE+$SWAP_SIZE\)/1024/1024)) 	# 单位换算
	
		DISK_FREE=0	# 初始化空闲磁盘大小为0
		SWAP_FREE=`free |grep Swap |awk '{print $4}'` # 空闲交换分区大小
		PARTITION_FREE=(`df -T |sed 1d |egrep -v "tmpfs" |awk '{print $5}'`)	# 以元组形式显示空闲硬盘大小
		for (( i=0; i<`echo ${#PARTITION_SIZE[*]}`; i++ ))	# 计算空闲磁盘大小
		do
			DISK_FREE=`expr $DISK_FREE + ${PARTITION_FREE[$i]}`
		done
		((DISK_FREE=\($DISK_FREE+$SWAP_FREE\)/1024/1024))	# 单位换算
	
		echo -e "\033[34m 磁盘总容量：${DISK_SIZE}GB\033[0m"
		echo -e "\033[34m 磁盘剩余容量：${DISK_FREE}GB\033[0m"
		;;
	    0)
		echo -e "\033[34m 感谢使用本系统！\033[0m"
		exit
		;;
	    *)
		echo -e "\033[34m Wrong input,please input again!\033[0m"	# 输入错误，请重新输入
	esac
done
