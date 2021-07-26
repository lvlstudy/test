#!/bin/bash
#增加历史命令后面的时间戳
histroy_time()
{
add_time="export HISTTIMEFORMAT='%Y-%m-%d %H:%M:%S  '"
add_size="export HISTSIZE=2000"
time=`grep $add_time /etc/profile`
size=`grep $add_size /etc/profile`
if [ ! -z "$time" ];then
   echo "$add_time" >>/etc/profile
else
   echo "add_time已被添加过；请忽略！！"
fi
if [ ! -z "$size" ];then
   echo "$add_size" >>/etc/profile
else
   echo "add_size已被添加过；请忽略！！"
fi
source /etc/profile
}
histroy_time



