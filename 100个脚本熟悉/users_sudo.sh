#!/bin/bash
ipaddress=$(ifconfig eth0 |awk '/\<inet\>/{print $2}')
##设定没有输入参数脚本退出
if [ $# -eq 0 ]
then
    echo "未输入任何参数！！"
    echo "$0:usage error"
    exit 1
elif  grep -q $1 /etc/passwd
then
      echo "$1已存在于用户配置文件/etc/passwd中，创建$1忽略！！"
      exit 3
else
   useradd $1
   echo $2 |passwd --stdin $1
fi
##设定sudoers配置文件
num=$(grep -c ^$1  /etc/sudoers)
if [ $num -ne 0 ]
then
   echo "该$1已在/etc/sudoers配置文件中，已配置忽略！！"
else
    
   sed -i '/^root/a '$1' '$ipaddress'=(root) ALL' /etc/sudoers
   sleep 3
   grep ^$1 /etc/sudoers && echo "$1配置成功" || echo "$1配置失败"
fi
