#!/bin/bash
file_save="/home/weihu1/172.18.136.11_property.log"
date=`date +%Y_%m_%d_%H:%M:%S`
#cpu_idle=`top -b -n 1 | grep Cpu | awk '{print $8}' | cut -f 1 -d "%"`
#active_idle=`echo "100 - ${cpu_idle}"|bc`
disk_usage=`df -h / | awk 'NR==2{print $5}'`
disk_min=`df -h /run |awk '/run/{print $5}'`
u_mem=`free -m |awk '/Mem/{print $3}'`
t_mem=`free -m |awk '/Mem/{print $2}'`
mem_usage=`awk 'BEGIN{printf "%.f%%\n",('$u_mem'/'$t_mem')*100}'`
mem_min=`ps aux |sort -rnk 4 |head -1 |awk '{print $4}'`
[ ! -f $file_save ] && touch $file_save
[ ! -f "/home/weihu1/cpuusage.txt" ] && touch /home/weihu1/cpuusage.txt

cat /dev/null >/home/weihu1/cpuusage.txt
for i in `seq 10`; do echo `top -b -n1 | grep ^%Cpu | awk '{printf("Current CPU Utilization is : %.2f%"), 100-$8}'` >>/home/weihu1/cpuusage.txt; done 
max_cpu=`awk '{print $6}' /home/weihu1/cpuusage.txt |sort -rn|head -1`
min_cpu=`awk '{print $6}' /home/weihu1/cpuusage.txt |sort -n|head -1`
echo "##############巡检开始时间为$date#############"  >>$file_save
echo -e "CPU使用率（最高/最低）\t磁盘使用率（最高/最低）\t内存使用率（最高/最低）" >>$file_save

echo -e    "$max_cpu\t$min_cpu\t$disk_usage\t$disk_min\t$mem_usage\t$mem_min%" >>$file_save
echo "##############巡检结束时间为$date##############" >>$file_save

