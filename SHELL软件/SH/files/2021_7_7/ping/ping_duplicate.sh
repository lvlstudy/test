#!/bin/bash
#多线程同时ping主机IP地址：
#第一：使用自定义函数
pingduoduo(){
ping -c5 -i1 -W1 $1 
if [ $? -eq 0 ];then
  echo "$1 is up" >>ping_ok.log
else
  echo "$1 is down" >>ping_error.log
fi
}
#第二：使用for循环遍历文件
for i in `cat ip_hosts`
do  
  pingduoduo $i &
done 
wait
