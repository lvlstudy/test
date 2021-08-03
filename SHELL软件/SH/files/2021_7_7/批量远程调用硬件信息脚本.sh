#!/bin/bash
#批量远程调用脚本
for i in {1..18}
do
	if ping -c 1 -W 1 10.10.10.$i &> /dev/null ;then
		echo "10.10.10.$i is up"
		ssh 10.10.10.$i < hardware_info.sh >> allhw.txt
	else
		echo "10.10.10.$i is down"
	fi
done

